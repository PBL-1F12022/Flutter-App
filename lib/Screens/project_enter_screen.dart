// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbl2022_app/Widgets/appbar.dart';
import 'package:pbl2022_app/constants/size_constants.dart';
import 'package:pbl2022_app/constants/urls.dart';
import 'package:http/http.dart' as http;

class ProjectEnterScreen extends StatefulWidget {
  ProjectEnterScreen({Key? key}) : super(key: key);
  static const routeName = '/project_enter_screen';

  @override
  State<ProjectEnterScreen> createState() => _ProjectEnterScreenState();
}

class _ProjectEnterScreenState extends State<ProjectEnterScreen> {
  Future _addProject() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final url = Uri.parse(createProjectUrl);
    final data = {
      "name": _nameController.text.toString(),
      "description": _descriptionController.text.toString(),
      "askingPrice": int.parse(_askingPriceController.text.trim()),
      "equity": double.parse(_equityController.text.trim()) / 100,
    };
    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _askingPriceController = TextEditingController();

  final TextEditingController _equityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Add Project'),
        body: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.message),
                  label: Text('Project Name'),
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  icon: Icon(Icons.text_fields),
                  label: Text('Description'),
                ),
              ),
              TextFormField(
                controller: _askingPriceController,
                decoration: InputDecoration(
                  icon: Icon(Icons.currency_rupee),
                  iconColor: Colors.black,
                  label: Text('Asking price'),
                ),
              ),
              TextFormField(
                controller: _equityController,
                decoration: InputDecoration(
                  icon: Icon(Icons.percent),
                  iconColor: Colors.black,
                  label: Text('Equity'),
                ),
              ),
              TextButton(
                  onPressed: () {
                    _addProject();
                  },
                  child: Text('Add'))
            ],
          ),
        ),
      ),
    );
  }
}
