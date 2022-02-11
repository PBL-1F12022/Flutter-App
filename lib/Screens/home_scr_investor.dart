// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pbl2022_app/Widgets/Entr_profile_card.dart';
import 'package:pbl2022_app/constants/test_project_idea_list.dart';
import 'package:pbl2022_app/models/project_pitch.dart';

class HomeScreenInvestor extends StatelessWidget {
  final List<ProjectIdea> projects = getList;

  // const HomeScreenInvestor(this.projects);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home screen'),
        ),
        body: ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) => EntrProfileCard(
            askingPrice: projects[index].askingPrice,
            description: projects[index].description,
            equity: projects[index].equity,
            id: projects[index].id,
            owner: projects[index].owner,
            projName: projects[index].name,
          ),
        ),
      ),
    );
  }
}
