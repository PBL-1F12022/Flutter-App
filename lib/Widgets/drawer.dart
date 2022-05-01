// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pbl2022_app/Screens/my_investments_screen.dart';
import 'package:pbl2022_app/Screens/project_enter_screen.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({Key? key}) : super(key: key);

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
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(MyInvestmentsScreen.routeName);
            },
            child: Text('My Investments'),
          )
        ],
      ),
    );
  }
}
