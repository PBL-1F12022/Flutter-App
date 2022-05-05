// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbl2022_app/Screens/home_scr_entrepreneur.dart';
import 'package:pbl2022_app/Screens/home_scr_investor.dart';

import '../Screens/coins/coins.dart';
import '../Screens/my_investments_screen.dart';
import '../Screens/profile.dart';
import '../Screens/project_enter_screen.dart';
import '../Screens/signup_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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

  get iconButton {
    return IconButton(
      onPressed: _handleMenuButtonPressed,
      icon: Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  // IconButton getButton() {
  //   return IconButton(
  //     onPressed: _handleMenuButtonPressed,
  //     icon: Icon(
  //       Icons.menu,
  //       color: Colors.white,
  //     ),
  //   );
  // }
  String? userType;
  bool _isLoaded = false;
  @override
  void initState() {
    () async {
      userType = await storage.read(key: 'userType') as String;
    };
    super.initState();
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _advancedDrawerController = AdvancedDrawerController();

    void _handleMenuButtonPressed() {
      _advancedDrawerController.showDrawer();
    }

    return !_isLoaded
        ? Center(child: CircularProgressIndicator())
        : AdvancedDrawer(
            controller: _advancedDrawerController,
            child: userType == 'investor'
                ? HomeScreenInvestor(_advancedDrawerController)
                : HomeScreenEntrepreneur(_advancedDrawerController),
            drawer: !_isLoaded
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Container(
                    // decoration: BoxDecoration(border: Border.all()),
                    child: ListTileTheme(
                        child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ProjectEnterScreen.routeName);
                          },
                          title: Text('Add project'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(MyInvestmentsScreen.routeName);
                          },
                          title: Text('My Investments'),
                        ),
                        ListTile(
                          onTap: () {
                            //My Profile
                            Navigator.of(context).pushNamed(Profile.routeName);
                          },
                          title: Text('My Profile'),
                        ),
                        ListTile(
                          onTap: () {
                            _logOut();
                          },
                          title: Text('Log Out'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(Coins.routeName);
                          },
                          title: Text('Coin Portal'),
                        ),
                      ],
                    )),
                  )),
          );
  }
}
