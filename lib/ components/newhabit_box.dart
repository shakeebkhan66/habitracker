import 'package:flutter/material.dart';

class EnterNewHabitBox extends StatelessWidget {
  TextEditingController controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  EnterNewHabitBox(
      {Key? key,
      required this.controller,
      required this.onCancel,
      required this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green.shade50,
      content: TextFormField(
        controller: controller,
        decoration: const InputDecoration(),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: onSave,
              color: Colors.green.shade400,
              child: const Text("Save"),
            ),
            MaterialButton(
              onPressed: onCancel,
              color: Colors.red.shade400,
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }
}
