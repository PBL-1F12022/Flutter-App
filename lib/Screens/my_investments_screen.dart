// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
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
  Future _getMyInvestments() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
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
    return Scaffold(
      appBar: AppBar(
        title: Text('My Investments'),
      ),
      body: Center(
        child: _isFetched
            ? investments.isEmpty
                ? Text('No Investments')
                : ListView.builder(
                    itemCount: investments.length,
                    itemBuilder: (context, index) {
                      return EnterProfileCard(
                        equity: investments[index]['equity'],
                        askingPrice: investments[index]['amount'],
                        description: '',
                        id: '',
                        owner: '',
                        projName: '',
                      );
                    },
                  )
            : CircularProgressIndicator(),
        // child: Text('data'),
      ),
    );
  }
}
