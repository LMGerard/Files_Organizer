import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final String label;
  bool value;
  CheckBox({Key? key, required this.label, this.value = true})
      : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          widget.value = !widget.value;
        });
      },
      icon: widget.value
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      label: Text(widget.label),
    );
  }
}
