import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'checkbox.dart';

class AdvancedPanel extends StatefulWidget {
  final Map<String, CheckBox> _settings = {
    'last accessed': CheckBox(label: 'copy last accessed', value: true),
    'last modified': CheckBox(label: 'copy last modified', value: true),
  };

  Map<String, bool> get settings =>
      _settings.map((key, value) => MapEntry(key, value.value));

  AdvancedPanel({Key? key}) : super(key: key);

  @override
  State<AdvancedPanel> createState() => _AdvancedPanelState();
}

class _AdvancedPanelState extends State<AdvancedPanel> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: const Text(
        'Advanced:',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
      collapsed: Container(),
      expanded: SizedBox(
        height: 100,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget._settings.values.toList(),
          ),
        ),
      ),
    );
  }
}
