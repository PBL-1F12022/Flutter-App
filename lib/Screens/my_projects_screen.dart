// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/Screens/investor_details_screen.dart';
import 'package:pbl2022_app/Widgets/Entr_profile_card.dart';
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
      print(response.body);
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
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            InvestorDetails.routeName,
            arguments: curID,
          );
        },
        child: SizedBox(
          height: height,
          width: width,
          child: !_isLoaded
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (contex, index) {
                    curID = data[index]['_id'];
                    return EnterProfileCard(
                      askingPrice: data[index]['askingPrice'],
                      description: data[index]['description'],
                      equity: data[index]['equity'],
                      id: data[index]['_id'],
                      owner: 'You',
                      projName: data[index]['name'],
                      sector: data[index]['sector'],
                      sectorAccuracy: data[index]['sectorAccuracy'],
                      userType: 'entrepreneur',
                    );
                  }),
        ),
      ),
    );
  }
}
