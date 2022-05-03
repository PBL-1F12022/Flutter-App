// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbl2022_app/Screens/coins/coins.dart';
import 'package:pbl2022_app/Screens/my_investments_screen.dart';
import 'package:pbl2022_app/Screens/project_enter_screen.dart';
import 'package:pbl2022_app/Screens/signup_screen.dart';

class HomeScreenDrawer extends StatelessWidget {
  final String userType;
  const HomeScreenDrawer(this.userType);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter App')),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ProjectEnterScreen.routeName);
            },
            child: Text('Add project'),
          ),
          if (userType == 'investor')
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MyInvestmentsScreen.routeName);
              },
              child: Text('My Investments'),
            ),
          TextButton(
            onPressed: () {
              //My Profile
            },
            child: Text('My Profile'),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Log Out'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Coins.routeName);
            },
            child: Text('Coin Portal'),
          ),
        ],
      ),
    );
  }
}
