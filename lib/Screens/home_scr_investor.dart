// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/Screens/drawers.dart';
import 'package:pbl2022_app/Screens/my_investments_screen.dart';
import 'package:pbl2022_app/Screens/my_projects_screen.dart';
import 'package:pbl2022_app/Widgets/Entr_profile_card.dart';
import 'package:pbl2022_app/Widgets/drawer.dart';
import 'package:pbl2022_app/constants/size_constants.dart';
import 'package:pbl2022_app/constants/urls.dart';
import 'package:pbl2022_app/models/project_pitch.dart';

class HomeScreenInvestor extends StatefulWidget {
  static const routeName = '/home-screen/investor';

  @override
  State<HomeScreenInvestor> createState() => _HomeScreenInvestorState();
}

class _HomeScreenInvestorState extends State<HomeScreenInvestor> {
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
    getProjectsList();
    super.initState();
  }

  void _selectIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final List screens = [
      RefreshIndicator(
        onRefresh: getProjectsList,
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
      if (userType == 'investor') MyInvestmentsScreen(),
      if (userType == 'entrepreneur') MyProjectsScreen(),
    ];

    SizeConfig.init(context);
    return _load
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
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
              drawer: HomeScreenDrawer(userType as String),
              appBar: AppBar(
                title: _index == 0
                    ? Text('Home screen')
                    : userType == 'investor'
                        ? Text('My Investments')
                        : Text('My Projects'),
              ),
              body: screens[_index],
            ),
          );
  }
}
