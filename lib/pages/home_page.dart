import 'package:flutter/material.dart';
import 'package:habitracker/%20components/my_fab.dart';

import '../ components/change_habit_dialog.dart';
import '../ components/habit_tile.dart';
import '../ components/newhabit_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO Controllers
  TextEditingController newHabitController = TextEditingController();

  // TODO Data Structure for Today Habit Tile List
  List todayHabitList = [
    // [habitName, habitCompleted]
    ["Morning Run", false],
    ["Read Book", false],
    ["Code App", false],
  ];

  // TODO Bool to control Habit Completed
  bool habitCompleted = false;

  // TODO CheckBox was Tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todayHabitList[index][1] = value;
    });
  }

  // TODO Create a New Habit
  void createNewHabit() {
    // Show the alert dialog box to enter the new habit
    showDialog(
        context: context,
        builder: (context) {
          return EnterNewHabitBox(
            controller: newHabitController,
            onSave: saveNewHabit,
            onCancel: cancelDialogBox,
          );
        });
  }

  // TODO SaveNewHabit
  void saveNewHabit() {
    // Add new habit to today habit list
    setState(() {
      todayHabitList.add([newHabitController.text, false]);
    });

    // clear Text Form Field
    newHabitController.clear();
    Navigator.of(context).pop();
  }

  // TODO CancelNewHabit
  void cancelDialogBox() {
    // clear Text Form Field
    newHabitController.clear();
    Navigator.of(context).pop();
  }

  // TODO Open Habit Setting
  void changeHabit(int index) {
    // Show the alert dialog box to enter the new habit
    showDialog(
        context: context,
        builder: (context) {
          return ChangeHabitDialog(
            controller: newHabitController,
            hintText: todayHabitList[index][0],
            onSave: () => newHabitSave(index),
            onCancel: cancelDialogBox,
          );
        });
  }

  // TODO Delete Habit
  void deleteHabit(int index) {
    setState(() {
      todayHabitList.removeAt(index);
    });
  }

  // TODO Save Change Habit
  void newHabitSave(int index) {
    setState(() {
      todayHabitList[index][0] = newHabitController.text;
    });
    newHabitController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.green.shade200,
          title: const Text(
            "Habit Tracker",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: MyFloatingActionButton(
          onChanged: createNewHabit,
        ),
        body: ListView.builder(
          itemCount: todayHabitList.length,
          itemBuilder: (context, index) {
            return HabitTile(
              habitName: todayHabitList[index][0],
              habitCompleted: todayHabitList[index][1],
              onChanged: (value) => checkBoxTapped(value, index),
              settingTapped: (context) => changeHabit(index),
              deleteTapped: (context) => deleteHabit(index),
            );
          },
        ));
  }
}
