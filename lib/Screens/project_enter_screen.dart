// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/constants/size_constants.dart';
import 'package:pbl2022_app/constants/urls.dart';

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('Project details')),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/background.jpg"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.225), BlendMode.dstIn),
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                top: 80,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: Color.fromARGB(255, 255, 169, 0),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            cursorColor: Color.fromARGB(255, 255, 169, 0),
                            controller: _nameController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.message),
                              label: Text(
                                'Project Name',
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.text_fields),
                              label: Text('Description'),
                            ),
                            maxLines: 4,
                          ),
                          TextFormField(
                            controller: _askingPriceController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.currency_rupee),
                              label: Text('Asking price'),
                            ),
                          ),
                          TextFormField(
                            controller: _equityController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.percent),
                              label: Text('Equity'),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 169, 0),
                            ),
                            onPressed: () {
                              _addProject();
                            },
                            child: Text('Add'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
