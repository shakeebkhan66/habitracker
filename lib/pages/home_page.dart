import 'package:flutter/material.dart';
import 'package:habitracker/%20components/month_summary.dart';
import 'package:habitracker/%20components/my_fab.dart';
import 'package:habitracker/data/habit_database.dart';
import 'package:hive/hive.dart';

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
  bool habitCompleted = false;
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    // If there is no current habit list, then it is the 1st time ever opening
    // the app then create default data
    if(_myBox.get("CURRENT_HABIT_LIST") == null){
      db.createDefaultData();
    }
    // there already exist data, then load data
    else{
      db.loadData();
    }

    // Update the database
    db.updateDatabase();
    super.initState();
  }



  // TODO Data Structure for Today Habit Tile List
  // List todayHabitList = [
  //   // [habitName, habitCompleted]
  //   ["Morning Run", false],
  //   ["Read Book", false],
  //   ["Code App", false],
  // ];

  // TODO Bool to control Habit Completed




  // TODO CheckBox was Tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value;
    });
    db.updateDatabase();
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
      db.todayHabitList.add([newHabitController.text, false]);
    });

    // clear Text Form Field
    newHabitController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
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
            hintText: db.todayHabitList[index][0],
            onSave: () => newHabitSave(index),
            onCancel: cancelDialogBox,
          );
        });
  }

  // TODO Delete Habit
  void deleteHabit(int index) {
    setState(() {
      db.todayHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  // TODO Save Change Habit
  void newHabitSave(int index) {
    setState(() {
      db.todayHabitList[index][0] = newHabitController.text;
    });
    newHabitController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
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
        body: ListView(
          children: [
            // Monthly Summary Heat Map
            MonthlySummary(datasets: db.heatMapDataSet, startDate: _myBox.get("START_DATE")),

            // List of Habit
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.todayHabitList.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habitName: db.todayHabitList[index][0],
                  habitCompleted: db.todayHabitList[index][1],
                  onChanged: (value) => checkBoxTapped(value, index),
                  settingTapped: (context) => changeHabit(index),
                  deleteTapped: (context) => deleteHabit(index),
                );
              },
            )
          ],
        )
    );
  }
}
