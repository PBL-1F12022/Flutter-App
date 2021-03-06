// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pbl2022_app/Screens/coins/coins.dart';
import 'package:pbl2022_app/Screens/home_scr_entrepreneur.dart';
import 'package:pbl2022_app/Screens/home_scr_investor.dart';
import 'package:pbl2022_app/Screens/investor_details_screen.dart';
import 'package:pbl2022_app/Screens/my_investments_screen.dart';
import 'package:pbl2022_app/Screens/profile.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(255, 255, 169, 0),
        ),
        // primarySwatch: Color.fromARGB(255, 255, 169, 0),
        textTheme: TextTheme(
          headline1: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 26, color: Colors.white),
          headline2: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white),
          headline3: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
          bodyText1: TextStyle(
            fontSize: 20,
          ),
        ),
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colors.amber,
            backgroundColor: Colors.purple,
            primarySwatch: Colors.purple,
          ),
        ),
      ),
      home: SignupScreen(),
      routes: {
        ProjectEnterScreen.routeName: (context) => ProjectEnterScreen(),
        HomeScreenInvestor.routeName: (context) => HomeScreenInvestor(),
        HomeScreenEntrepreneur.routeName: (context) => HomeScreenEntrepreneur(),
        MyInvestmentsScreen.routeName: (context) => MyInvestmentsScreen(),
        Coins.routeName: (context) => Coins(),
        Profile.routeName: (context) => Profile(),
        SignupScreen.routeName: (context) => SignupScreen(),
        InvestorDetails.routeName: (context) => InvestorDetails(id: ''),
      },
    );
  }
}
