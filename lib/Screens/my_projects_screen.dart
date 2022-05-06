// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/Screens/investor_details_screen.dart';
import 'package:pbl2022_app/constants/urls.dart';

class MyProjectsScreen extends StatefulWidget {
  const MyProjectsScreen({Key? key}) : super(key: key);

  @override
  State<MyProjectsScreen> createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends State<MyProjectsScreen> {
  List data = [];
  bool _isLoaded = false;
  String curID = '';

  Future _getMyProjects() async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final url = Uri.parse(getMyProjectsUrl);
      final response = await http.get(url, headers: {
        "Authorization": 'Bearer $token',
      });
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          _isLoaded = true;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'No investments yet!',
          backgroundColor: Colors.blue.shade600,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong please try again later!',
        backgroundColor: Colors.blue.shade600,
      );
    }
  }

  @override
  void initState() {
    _getMyProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
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
        child: SizedBox(
          height: height,
          width: width,
          child: !_isLoaded
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    curID = data[index]['_id'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InvestorDetails(id: data[index]['_id']),
                          ),
                        );
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: AspectRatio(
                          aspectRatio: 3 / 1.5,
                          child: Card(
                            color: Color.fromARGB(32, 255, 255, 255),
                            elevation: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: width * (60 / 100),
                                  // decoration: BoxDecoration(border: Border.all()),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * (2 / 100),
                                    vertical: height * (1 / 100),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[index]['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 27,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: height * (1 / 100)),
                                      Text(
                                        "Asking Price: " +
                                            data[index]['askingPrice']
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "Equity: " +
                                            data[index]['equity']
                                                .toStringAsFixed(2) +
                                            "%",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "Sector: " + data[index]['sector'],
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "Sector Accuracy: " +
                                            data[index]['sectorAccuracy']
                                                .toStringAsFixed(3),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "Investors: " +
                                            (data[index]['investorDetails'])
                                                .length
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     // Navigator.of(context).pushNamed(
                                      //     //   InvestorDetails.routeName,
                                      //     //   arguments: curID,
                                      //     // );
                                      //     var abc = GestureBinding.instance;
                                      //     // curID = GestureBinding.instance.;
                                      //     print(curID);
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             InvestorDetails(
                                      //                 id: data[index]['_id']),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.work,
                                  color: Colors.white,
                                  size: 100,
                                ),

                                // Image(
                                //   image: NetworkImage(
                                //     'https://c8.alamy.com/zooms/9/740e1ea2478b41efab9000300b84521b/r1t00k.jpg',
                                //   ),
                                //   fit: BoxFit.cover,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    // return EnterProfileCard(
                    //   askingPrice: data[index]['askingPrice'],
                    //   description: data[index]['description'],
                    //   equity: data[index]['equity'],
                    //   id: data[index]['_id'],
                    //   owner: 'You',
                    //   projName: data[index]['name'],
                    //   sector: data[index]['sector'],
                    //   sectorAccuracy: data[index]['sectorAccuracy'],
                    //   userType: 'entrepreneur',
                    // );
                  }),
        ),
      ),
    );
  }
}
