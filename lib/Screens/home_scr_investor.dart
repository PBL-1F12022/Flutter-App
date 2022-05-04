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

class InvestDialog extends StatelessWidget {
  final String id;
  const InvestDialog({required this.id});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 51, 51, 51),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(0.0, 2.0)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: deviceHeight * 0.02),
                alignment: Alignment.center,
                child: Column(
                  children: const [
                    Text(
                      "Investment",
                      style: TextStyle(
                        color: Color(0xffe20000),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Rajdhani',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "You can invest in this project!",
                      style: TextStyle(
                        color: Color.fromARGB(255, 161, 161, 161),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Rajdhani',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 26,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: deviceHeight * 0.055,
                      width: deviceHeight * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: const Color(0xffe20000),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return BuyInvestDialog(id: id);
                          });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: deviceHeight * 0.055,
                      width: deviceHeight * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: const Color(0xffe20000),
                      ),
                      child: const Text(
                        "Invest",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 15,
          left: 10,
          right: 10,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Image.network(
                "https://icon-library.com/images/investment-icon-png/investment-icon-png-6.jpg"),
          ),
        ),
      ],
    );
  }
}

class BuyInvestDialog extends StatelessWidget {
  final String id;
  BuyInvestDialog({required this.id});
  final storage = const FlutterSecureStorage();
  final TextEditingController _buyCoin = TextEditingController();

  Future investProject() async {
    try {
      Map data = {
        "project_id": id,
        "amount": int.parse(_buyCoin.text.trim()),
      };

      final token = await storage.read(key: 'token');

      final response = await http.post(
        Uri.parse(investUrl),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: result['msg'] ?? "Coins debited from account",
          backgroundColor: Colors.red.shade600,
        );
      } else {
        var result = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: result['msg'] ?? "Error while performing transaction",
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
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 51, 51, 51),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(0.0, 2.0)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: deviceHeight * 0.02),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Invest",
                      style: TextStyle(
                        color: Color(0xffe20000),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Rajdhani',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: size.height * 0.90,
                        height: size.width * 0.20,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 77, 207, 7),
                              Color.fromARGB(255, 155, 236, 123),
                            ],
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 253, 243, 243),
                              offset: Offset(
                                1.0,
                                1.0,
                              ),
                              blurRadius: 3.0,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 155, 236, 123),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await investProject();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Buy",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: TextFormField(
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    controller: _buyCoin,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: "0",
                                      hintStyle: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 26,
              ),
            ],
          ),
        ),
        Positioned(
          top: 15,
          left: 10,
          right: 10,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Image.network(
                "https://icon-library.com/images/investment-icon-png/investment-icon-png-6.jpg"),
          ),
        ),
      ],
    );
  }
}
