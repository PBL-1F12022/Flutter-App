// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/Screens/my_projects_screen.dart';
import 'package:pbl2022_app/Widgets/Entr_profile_card.dart';
import 'package:pbl2022_app/constants/size_constants.dart';
import 'package:pbl2022_app/constants/urls.dart';
import 'package:pbl2022_app/models/project_pitch.dart';

import '../Widgets/drawer_widget.dart';
import '../advance_drawer/flutter_advanced_drawer.dart';

class HomeScreenEntrepreneur extends StatefulWidget {
  static const routeName = '/home-screen/entrepreneur';

  @override
  State<HomeScreenEntrepreneur> createState() => _HomeScreenEntrepreneurState();
}

class _HomeScreenEntrepreneurState extends State<HomeScreenEntrepreneur> {
  String? userType;
  bool _load = true;
  List<ProjectIdea> projects = [];

  Future getProjectsList() async {
    projects.clear();
    final storage = FlutterSecureStorage();
    userType = (await storage.read(key: 'userType'))!;
    Future.delayed(Duration.zero);
    try {
      // userType = (await storage.read(key: 'userType'))!;
      final response = await http.get(Uri.parse(getProjectsUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        // print(data);
        for (var project in data) {
          projects.add(ProjectIdea.fromJson(project));
        }
        setState(() {
          _load = false;
        });
        // print(response.statusCode);
        // print(projects);
      } else {
        Fluttertoast.showToast(
          msg: 'Projects are not currently available',
          backgroundColor: Colors.red.shade600,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Please try again later',
        backgroundColor: Colors.red.shade600,
      );
    }
  }

  @override
  void initState() {
    // storage.deleteAll();
    // Future.delayed(Duration.zero, () {});
    // loadUserType();
    print('Home screen called');
    getProjectsList();
    super.initState();
  }

  void _selectIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  final _advancedDrawerController = AdvancedDrawerController();

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final List screens = [
      RefreshIndicator(
        onRefresh: () async {
          await getProjectsList();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/background.jpg"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.darken),
            ),
          ),
          child: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) => EnterProfileCard(
              askingPrice: projects[index].askingPrice,
              description: projects[index].description,
              equity: projects[index].equity,
              id: projects[index].id,
              owner: projects[index].ownerName,
              projName: projects[index].name,
              sector: projects[index].sector,
              sectorAccuracy: projects[index].sectorAccuracy,
              userType: userType as String,
            ),
          ),
        ),
      ),
      MyProjectsScreen(),
    ];

    SizeConfig.init(context);
    return _load
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : AdvancedDrawer(
            backdropColor: const Color(0xff01020a),
            controller: _advancedDrawerController,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            animateChildDecoration: true,
            rtlOpening: false,
            disabledGestures: false,
            childDecoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: SafeArea(
              child: Scaffold(
                body: screens[_index],
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Color.fromARGB(255, 255, 169, 0),
                  selectedItemColor: Colors.white,
                  onTap: _selectIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'All Projects',
                    ),
                    BottomNavigationBarItem(
                      icon: userType == 'investor'
                          ? Icon(Icons.money_rounded)
                          : Icon(Icons.work),
                      label: userType == 'investor'
                          ? 'My Investments'
                          : 'My Projects',
                    ),
                  ],
                  currentIndex: _index,
                ),
                appBar: AppBar(
                  backgroundColor: Color.fromARGB(255, 255, 169, 0),
                  automaticallyImplyLeading: _index == 0 ? true : false,
                  centerTitle: true,
                  titleSpacing: 0,
                  elevation: 5,
                  titleTextStyle: TextStyle(
                    fontSize: 25,
                  ),
                  title:
                      _index == 0 ? Text('Home Screen') : Text('My Projects'),
                  leading: IconButton(
                    onPressed: _handleMenuButtonPressed,
                    icon: ValueListenableBuilder<AdvancedDrawerValue>(
                      valueListenable: _advancedDrawerController,
                      builder: (_, value, __) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            value.visible ? Icons.clear : Icons.menu,
                            key: ValueKey<bool>(value.visible),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            drawer: DrawerWidget(userType: userType as String),
          );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
