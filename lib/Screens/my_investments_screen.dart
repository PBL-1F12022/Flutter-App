// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/Screens/signup_screen.dart';
import 'package:pbl2022_app/Widgets/Entr_profile_card.dart';

import 'package:pbl2022_app/constants/urls.dart';

class MyInvestmentsScreen extends StatefulWidget {
  const MyInvestmentsScreen({Key? key}) : super(key: key);
  static const routeName = '/my_investments_screen';
  @override
  State<MyInvestmentsScreen> createState() => _MyInvestmentsScreenState();
}

class _MyInvestmentsScreenState extends State<MyInvestmentsScreen> {
  bool _isFetched = false;
  List investments = [];
  String? userType;
  Future _getMyInvestments() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    userType = await storage.read(key: 'userType');
    final url = Uri.parse(getInvestmentsUrl);

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {
      investments = data;
      _isFetched = true;
    });
  }

  @override
  void initState() {
    _getMyInvestments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    late final width = mediaQuery.size.width;
    late final height = mediaQuery.size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/background.jpg"),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8), BlendMode.darken),
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _getMyInvestments,
          child: Center(
            child: _isFetched
                ? investments.isEmpty
                    ? Text('No Investments')
                    : ListView.builder(
                        itemCount: investments.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * (2 / 100),
                              vertical: height * (1 / 100),
                            ),
                            child: AspectRatio(
                              aspectRatio: 3 / 1,
                              child: Card(
                                color: Color.fromARGB(32, 255, 255, 255),
                                elevation: 22,
                                child: Container(
                                  // decoration: BoxDecoration(border: Border.all()),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * (1 / 100),
                                    vertical: height * (0.5 / 100),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: width * (60 / 100),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              investments[index]['project']
                                                  ['name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(
                                                height: height * (1 / 100)),
                                            Text(
                                              "Equity:  " +
                                                  investments[index]['equity']
                                                      .toStringAsFixed(2) +
                                                  " %",
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(
                                                height: height * (0.3 / 100)),
                                            Text(
                                              "Amount: " +
                                                  investments[index]['amount']
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(
                                                height: height * (0.3 / 100)),
                                            Text(
                                              "Sector: " +
                                                  investments[index]['project']
                                                      ['sector'],
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.currency_rupee,
                                        size: 60,
                                        color: Colors.white
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                : CircularProgressIndicator(),
            // child: Text('data'),
          ),
        ),
      ),
    );
    // return RefreshIndicator(
    //   onRefresh: _getMyInvestments,
    //   child: Center(
    //     child: _isFetched
    //         ? investments.isEmpty
    //             ? Text('No Investments')
    //             : ListView.builder(
    //                 itemCount: investments.length,
    //                 itemBuilder: (context, index) {
    //                   return EnterProfileCard(
    //                     equity: investments[index]['equity'],
    //                     askingPrice: investments[index]['amount'],
    //                     description: investments[index]['project']
    //                         ['description'],
    //                     id: investments[index]['project']['_id'],
    //                     owner: investments[index]['project']['ownerName'],
    //                     projName: investments[index]['project']['name'],
    //                     sector: investments[index]['project']['sector'],
    //                     sectorAccuracy: investments[index]['project']
    //                         ['sectorAccuracy'],
    //                   );
    //                 },
    //               )
    //         : CircularProgressIndicator(),
    //     // child: Text('data'),
    //   ),
    // );
  }
}
