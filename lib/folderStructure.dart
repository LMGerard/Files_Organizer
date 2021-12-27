import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:photos_organizer/fileManager.dart';

class FolderStructurePanel extends StatefulWidget {
  final dirController = TextEditingController();
  final fileController = TextEditingController();
  Structure get structure => Structure(dirController.text, fileController.text);
  FolderStructurePanel({Key? key}) : super(key: key);

  @override
  State<FolderStructurePanel> createState() => _FolderStructurePanelState();
}

class _FolderStructurePanelState extends State<FolderStructurePanel> {
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: const Text(
        'Folder Structure:',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
      collapsed: Container(),
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.contains(RegExp(r"[:*?|\\]|//+"))) {
                      return "Directories and files can't contain : \\ ? * |";
                    }
                  },
                  controller: widget.dirController,
                  decoration: const InputDecoration(
                    hintText: "<year>/hello-<month>",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text('/', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.contains(RegExp(r"[:*?|\\]|//+"))) {
                      return "Directories and files can't contain : \\ ? * |";
                    }
                  },
                  controller: widget.fileController,
                  decoration: const InputDecoration(
                    hintText: "num-<increment>",
                  ),
                ),
              ),
              const Text('.ext', style: TextStyle(fontSize: 20)),
            ],
          ),
          const Center(
            child: Text(
              "<year> <month> <day> <hh> <mm> <ss> <filename> <increment (only one)>",
            ),
          ),
        ],
      ),
    );
  }
}


