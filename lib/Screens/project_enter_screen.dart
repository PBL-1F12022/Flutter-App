// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pbl2022_app/constants/size_constants.dart';

class ProjectEnterScreen extends StatelessWidget {
  const ProjectEnterScreen({Key? key}) : super(key: key);
  static const routeName = '/project_enter_screen';
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Project details')),
        body: Container(
          height: SizeConfig.getProportionateScreenHeight(320),
          width: SizeConfig.getProportionateScreenWidth(350),
          // decoration: BoxDecoration(border: Border.all()),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 200),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.message),
                    label: Text('Project Name'),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.text_fields),
                    label: Text('Description'),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.currency_rupee),
                    iconColor: Colors.black,
                    label: Text('Asking price'),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.percent),
                    iconColor: Colors.black,
                    label: Text('Equity'),
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('Add'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
