// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbl2022_app/Screens/coins/coins.dart';
import 'package:pbl2022_app/Screens/my_investments_screen.dart';
import 'package:pbl2022_app/Screens/profile.dart';
import 'package:pbl2022_app/Screens/project_enter_screen.dart';
import 'package:pbl2022_app/Screens/signup_screen.dart';

class HomeScreenDrawer extends StatefulWidget {
  final String userType;
  const HomeScreenDrawer(this.userType);

  @override
  State<HomeScreenDrawer> createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer> {
  final storage = FlutterSecureStorage();
  Future _logOut() async {
    await storage.deleteAll();
    // final str = await storage.read(key: 'userType');
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed(SignupScreen.routeName);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (widget.userType == 'entrepreneur')
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ProjectEnterScreen.routeName);
              },
              child: Text('Add project'),
            ),
          if (widget.userType == 'investor')
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MyInvestmentsScreen.routeName);
              },
              child: Text('My Investments'),
            ),
          TextButton(
            onPressed: () {
              //My Profile
              Navigator.of(context).pushNamed(Profile.routeName);
            },
            child: Text('My Profile'),
          ),
          TextButton(
            onPressed: () {
              _logOut();
            },
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
