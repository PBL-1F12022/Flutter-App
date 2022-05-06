import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbl2022_app/Screens/coins/coins.dart';

import '../Screens/my_investments_screen.dart';
import '../Screens/profile.dart';
import '../Screens/project_enter_screen.dart';
import '../Screens/signup_screen.dart';

class DrawerWidget extends StatefulWidget {
  final String userType;

  const DrawerWidget({
    Key? key,
    required this.userType,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final storage = const FlutterSecureStorage();

  Future _logOut() async {
    await storage.deleteAll();
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed(SignupScreen.routeName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 120.0,
              child: Center(
                  child: Text(
                'Pitch & Fund',
                style: TextStyle(fontSize: 35, color: Colors.white),
              )),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                height: 5.0,
                thickness: 2,
                color: Colors.grey,
              ),
            ),
            if (widget.userType == 'entrepreneur')
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    TransitionAnimationRightToLeft(const ProjectEnterScreen()),
                  );
                },
                leading: const Icon(Icons.add, size: 30),
                title: const Text(
                  'Add project',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (widget.userType == 'investor')
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    TransitionAnimationRightToLeft(const MyInvestmentsScreen()),
                  );
                },
                leading: const Icon(Icons.currency_rupee, size: 30),
                title: const Text(
                  'My Investments',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, TransitionAnimationRightToLeft(const Profile()));
              },
              leading: const Icon(Icons.account_circle, size: 30),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, TransitionAnimationRightToLeft(const Coins()));
              },
              leading: const Icon(Icons.attach_money, size: 30),
              title: const Text(
                'Coin Portal',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                height: 5.0,
                thickness: 2,
                color: Colors.grey,
              ),
            ),
            ListTile(
              onTap: () {
                _logOut();
              },
              leading: const Icon(Icons.exit_to_app, size: 30),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                height: 5.0,
                thickness: 2,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: const Text('Terms of Service | Privacy Policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransitionAnimationRightToLeft extends PageRouteBuilder {
  final Widget page;

  TransitionAnimationRightToLeft(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.easeInOutCubicEmphasized,
                parent: animation,
                reverseCurve: Curves.fastOutSlowIn);
            return Align(
              alignment: Alignment.centerRight,
              child: SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: animation,
                child: page,
                axisAlignment: 0,
              ),
            );
          },
        );
}
