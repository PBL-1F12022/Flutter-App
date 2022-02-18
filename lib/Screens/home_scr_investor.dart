// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbl2022_app/Widgets/Entr_profile_card.dart';
import 'package:pbl2022_app/constants/test_project_idea_list.dart';
import 'package:pbl2022_app/constants/urls.dart';
import 'package:pbl2022_app/models/project_pitch.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreenInvestor extends StatefulWidget {
  @override
  State<HomeScreenInvestor> createState() => _HomeScreenInvestorState();
}

class _HomeScreenInvestorState extends State<HomeScreenInvestor> {
  // final List<ProjectIdea> projects = getList;
  bool _load = true;
  List<ProjectIdea> projects = [];
  Future getProjectsList() async {
    projects.clear();
    try {
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
    getProjectsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _load
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              drawer: Column(),
              appBar: AppBar(
                title: Text('Home screen'),
              ),
              body: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) => EnterProfileCard(
                  askingPrice: projects[index].askingPrice,
                  description: projects[index].description,
                  equity: projects[index].equity,
                  id: projects[index].id,
                  owner: projects[index].ownerName,
                  projName: projects[index].name,
                ),
              ),
            ),
          );
  }
}
