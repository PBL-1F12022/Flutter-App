// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:pbl2022_app/Screens/home_scr_investor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          headline2: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          bodyText1: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      home: HomeScreenInvestor(),
    );
  }
}
