import 'package:habitracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Reference Our Box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todayHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};


  void createDefaultData() {
    todayHabitList = [
      ["Run", false],
      ["Read", false]
    ];
    _myBox.put("START_DATE", todaysDateFormatted());
  }

  void loadData() {
    // If it's a new day, get habit list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      todayHabitList = _myBox.get("CURRENT_HABIT_LIST");
      // See all habit completed to false since it's a new day
      for (int i = 0; i < todayHabitList.length; i++) {
        todayHabitList[i][1] == false;
      }
    }
    // If it's not a new day, load todays list
    else {
      todayHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  void updateDatabase() {
    // Update Today Entry
    _myBox.put(todaysDateFormatted(), todayHabitList);

    // Update Universal Habit List in case it changed (New Habit, Edit Habit,
    // Delete Habit)
    _myBox.put("CURRENT_HABIT_LIST", todayHabitList);

    // Calculate Habit Complete Percentage for Each Day
    calculateHabitPercentage();

    // Load Heat Map
    loadHeatMap();
  }

  void calculateHabitPercentage() {
    int countCompleted = 0;
    for (int i = 0; i < todayHabitList.length; i++) {
      if (todayHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todayHabitList.isEmpty
        ? "0.0"
        : (countCompleted / todayHabitList.length).toStringAsFixed(1);

    // Key: "Percentage Summary yyyy mm dd"
    // Value: String of IDP Number between 0.0-1.0 Inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
