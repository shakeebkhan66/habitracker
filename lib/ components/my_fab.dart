import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function()? onChanged;
  const MyFloatingActionButton({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: onChanged,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.green.shade200,
      child: const Icon(Icons.add, size: 30.0,),
    );
  }
}
