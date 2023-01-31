import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  String habitName;
  bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingTapped;
  final Function(BuildContext)? deleteTapped;
  HabitTile(
      {Key? key,
      required this.habitName,
      required this.habitCompleted,
      required this.onChanged,
      required this.settingTapped,
      required this.deleteTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // Setting Action
            SlidableAction(
              onPressed: settingTapped,
              backgroundColor: Colors.green.shade500,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8.0),
            ),
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete_forever_outlined,
              borderRadius: BorderRadius.circular(8.0),
            )
          ],
        ),
        child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Checkbox(value: habitCompleted, onChanged: onChanged),
                Text(habitName),
              ],
            )),
      ),
    );
  }
}
