import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:photos_organizer/advanced.dart';
import 'checkbox.dart';
import 'directorySelector.dart';
import 'extensions.dart';
import 'folderStructure.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Files Organizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Files Organizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _directorySelector = DirectorySelector(label: 'Directory');
  final _subdirectories = CheckBox(label: 'include subdirectories');
  final _extensionsSelector = ExtensionsPanel();
  final _outputDirSelector = DirectorySelector(label: 'Output Directory');
  final _folderStructurePanel = FolderStructurePanel();
  final _advanced = AdvancedPanel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _directorySelector,
                const SizedBox(height: 8),
                _subdirectories,
                const SizedBox(height: 8),
                _outputDirSelector,
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        copyFiles();
                      }
                    },
                    icon: const Icon(Icons.file_copy),
                    label: const Text('Copy files'),
                  ),
                ),
                _folderStructurePanel,
                _advanced,
                _extensionsSelector,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void copyFiles() async {
    final progress = ValueNotifier(0);
    final filesNumber = ValueNotifier(1);
    final struct = _folderStructurePanel.structure;
    showAlertDialog(context, progress, filesNumber);

    final directory = Directory(_directorySelector.dir);
    final outputDir = _outputDirSelector.dir;
    final includeSubdirectories = _subdirectories.value;
    final extensions = _extensionsSelector.extensions;

    final test = directory.list(recursive: includeSubdirectories);
    filesNumber.value = await test.length;

    final files =
        directory.listSync(recursive: includeSubdirectories).where((e) {
      if (e is! File) return false;

      if (extensions[getExtension(e.path)] == false ||
          (extensions[getExtension(e.path)] == null &&
              extensions['unlisted'] == false)) return false;

      return true;
    });

    struct
        .map(files.map((e) => File(e.path)))
        .takeWhile((_) => progress.value >= 0)
        .forEach((e) async {
      progress.value++;
      String path = p.join(outputDir, e.value);
      final file = e.key;

      try {
        await Directory(p.dirname(path)).create(recursive: true);
      } on Exception catch (_) {}

      try {
        await file.copy(path);
        File(path).setLastAccessed(file.lastAccessedSync());
        File(path).setLastModified(file.lastModifiedSync());
      } on Exception {
        final i = generateNum().firstWhere(
          (i) => !File(p.join(p.dirname(path),
                  p.basename(path) + '-$i' + p.extension(path)))
              .existsSync(),
        );

        try {
          path = p.join(
            p.dirname(path),
            p.basename(path) + '-$i' + p.extension(path),
          );
          await file.copy(path);
          File(path).setLastAccessed(file.lastAccessedSync());
          File(path).setLastModified(file.lastModifiedSync());
        } catch (_) {}
      }
    }).then((value) {
      Navigator.of(context).pop();
    });
  }

  Iterable<int> generateNum() sync* {
    int n = 0;
    while (true) {
      yield n++;
    }
  }

  showAlertDialog(BuildContext context, ValueNotifier<int> progress,
      ValueNotifier<int> filesNumber) {
    AlertDialog alert = AlertDialog(
      title: const Text("Copying files"),
      content: ValueListenableBuilder<int>(
        valueListenable: progress,
        builder: (context, value, child) {
          return LinearProgressIndicator(
            value: value / filesNumber.value,
          );
        },
        child: Text('${progress.value}/${filesNumber.value}'),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => progress.value = -1,
        ),
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

String getExtension(String path) {
  return p.extension(path).substring(1);
}
