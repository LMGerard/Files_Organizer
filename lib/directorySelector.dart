import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class DirectorySelector extends StatelessWidget {
  final _textController = TextEditingController();
  final String label;
  String get dir => _textController.text;

  DirectorySelector({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: TextFormField(
          controller: _textController,
          decoration: InputDecoration(labelText: label),
          validator: (value) {
            if (value == null || !Directory(value).existsSync()) {
              return 'Directory does not exist';
            }
            return null;
          },
        )),
        IconButton(
          onPressed: () async {
            String? selectedDir = await FilePicker.platform.getDirectoryPath();

            _textController.text = selectedDir ?? _textController.text;
          },
          icon: const Icon(Icons.folder_open),
        ),
      ],
    );
  }
}
