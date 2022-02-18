// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:pbl2022_app/Screens/home_scr_investor.dart';
import 'package:pbl2022_app/Screens/project_enter_screen.dart';
import 'package:pbl2022_app/Screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
          headline2: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          headline3: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
          bodyText1: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      // home: SignupScreen(),
      // home: ProjectEnterScreen(),
      home: HomeScreenInvestor(),
      routes: {
        ProjectEnterScreen.routeName: (context) => ProjectEnterScreen(),
      },
    );
  }
}
