import 'dart:async';

import 'package:flutter/material.dart';

import 'api/api.dart';
import 'database/appwrite.dart';
import 'screen.dart';
import 'todoapp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final week = {
    "Monday": 1,
    "Tuesday": 2,
    "Wednesday": 3,
    "Thursday": 4,
    "Friday": 5,
    "Saturday": 6,
    "Sunday": 7,
  };

  final timeone = DateTime.now().hour;
  final int timetwo = DateTime.now().minute;
  final int timethree = DateTime.now().second;

  final int year = DateTime.now().year;

  String getMonth() {
    final month = DateTime.now().month;

    switch (month) {
      case DateTime.january:
        return "January";
      case DateTime.february:
        return "February";
      case DateTime.march:
        return "March";
      case DateTime.april:
        return "April";
      case DateTime.may:
        return "May";
      case DateTime.june:
        return "June";
      case DateTime.july:
        return "July";
      case DateTime.august:
        return "August";
      case DateTime.september:
        return "September";
      case DateTime.october:
        return "October";
      case DateTime.november:
        return "November";
      case DateTime.december:
        return "December";
      default:
        return "Some other month";
    }
  }

  String days() {
    final day = DateTime.now().weekday;

    switch (day) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      case DateTime.sunday:
        return "Sunday";
      default:
        return "Some other day";
    }
  }

  List<Map<String, dynamic>> _todo = [];
  bool _isLoading = true;
  Future<void> _refreshTodo() async {
    final data = await SQLHELPER.getItems();
    setState(() {
      _todo = data;
      _isLoading = false;
    });
  }

  late DateTime currentTime;
  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    // Update the time every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        hoverColor: Colors.red,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TodoApp()));
        },
        child: const Icon(
          Icons.arrow_upward_sharp,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${getMonth()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size * .05,
                      ),
                    ),
                  ],
                ),
                Text(
                  " ${currentTime.hour}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * .3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " ${currentTime.minute}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size * .3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${currentTime.second} s",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size * .02,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${days()}, $year",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * .03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
