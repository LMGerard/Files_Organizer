import 'package:path/path.dart' as p;
import 'dart:io';


class Structure {
  final Map<String, Function(SubFile)> functions = {
    'year': (d) =>
        d.copyPath.replaceFirst('<year>', d.stat.changed.year.toString()),
    'month': (d) => d.copyPath.replaceFirst(
        '<month>', d.stat.changed.month.toString().padLeft(2, '0')),
    'day': (d) => d.copyPath
        .replaceFirst('<day>', d.stat.changed.day.toString().padLeft(2, '0')),
    'hh': (d) => d.copyPath
        .replaceFirst('<hh>', d.stat.changed.hour.toString().padLeft(2, '0')),
    'mm': (d) => d.copyPath
        .replaceFirst('<mm>', d.stat.changed.minute.toString().padLeft(2, '0')),
    'ss': (d) => d.copyPath
        .replaceFirst('<ss>', d.stat.changed.second.toString().padLeft(2, '0')),
    'filename': (d) => d.copyPath
        .replaceFirst('<filename>', p.basenameWithoutExtension(d.file.path)),
    'increment': (d) => d.copyPath,
  };
  final increments = <String, int>{};

  final String struct;
  final List<Function(SubFile)> structSteps = [];
  Structure(String dirStruct, String fileStruct)
      : struct =
            dirStruct + '/' + (fileStruct.isEmpty ? '<filename>' : fileStruct) {
    functions['increment'] = (d) {
      increments[d.copyPath] = (increments[d.copyPath] ?? -1) + 1;
      return d.copyPath
          .replaceFirst('<increment>', increments[d.copyPath].toString());
    };

    final matches =
        RegExp(functions.keys.map((e) => '<$e>').join('|')).allMatches(struct);
    for (final e in matches) {
      final k = functions[struct.substring(e.start + 1, e.end - 1)]!;
      structSteps.add(k);
    }
  }

  Stream<MapEntry<File, String>> map(Iterable<File> files) async* {
    for (final f in files) {
      f.openSync()
        ..flushSync()
        ..closeSync();
      print(FileStat.statSync(f.path));
      try {
        final subFile = SubFile(f);

        for (final step in structSteps) {
          subFile.copyPath = step(subFile);
        }
        final path =
            p.joinAll(subFile.copyPath.split('/')) + p.extension(f.path);
        print(path);
        yield MapEntry(f, path);
      } catch (e) {
        yield MapEntry(f, p.join('unknown', p.basename(f.path)));
      }
    }
  }
}

class SubFile {
  final File file;
  final FileStat stat;
  String copyPath = '';
  SubFile(this.file) : stat = FileStat.statSync(file.path);
}