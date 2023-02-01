import 'package:hive_flutter/hive_flutter.dart';

// Reference Our Box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase{
  List todayHabitList = [];

  void createDefaultData(){
    todayHabitList = [
      ["Run", false],
      ["Read", false]
    ];
  }
  void loadData(){}
  void updateDatabase(){}
}