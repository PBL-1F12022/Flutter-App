// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ProjectEnterScreen extends StatelessWidget {
  const ProjectEnterScreen({Key? key}) : super(key: key);
  static const routeName = '/project_enter_screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Project details')),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Project Name'),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Description'),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Asking price'),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Equity'),
                  ),
                ),
                TextButton(onPressed: () {}, child: Text(''))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
