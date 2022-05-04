// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:pbl2022_app/constants/urls.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class InvestorDetails extends StatefulWidget {
  String id;
  InvestorDetails({Key? key, required this.id}) : super(key: key);
  static const routeName = '/investor_details_screen';

  @override
  State<InvestorDetails> createState() => _InvestorDetailsState();
}

class _InvestorDetailsState extends State<InvestorDetails> {
  List data = [];
  List investors = [];
  bool _isLoaded = false;
  Future _getInvestors() async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final url = Uri.parse(getInvestorsListUrl);
      final response = await http.get(
        url,
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          data = jsonDecode(response.body);
          for (var map in data) {
            if (map['_id'] == widget.id) {
              investors.add(map);
            }
          }
          _isLoaded = true;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong!',
          backgroundColor: Colors.blue.shade600,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.blue.shade600,
      );
    }
  }

  @override
  void initState() {
    // print(widget.id);
    _getInvestors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Investors List'),
      ),
      body: !_isLoaded
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InvestorCard(
                  height: height,
                  name: investors[0]['investorDetails'][0]['name'],
                  amount: investors[0]['investorDetails'][0]['amount'],
                  equity: investors[0]['investorDetails'][0]['equity'],
                );
              },
            ),
    );
  }
}

class InvestorCard extends StatelessWidget {
  const InvestorCard({
    Key? key,
    required this.height,
    required this.name,
    required this.amount,
    required this.equity,
  }) : super(key: key);

  final double height;
  final String name;
  final int amount;
  final double equity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(height * (1.5 / 100)),
      child: AspectRatio(
        aspectRatio: 3 / 1.5,
        child: Card(
          elevation: 10,
          child: Column(
            children: [
              Text(name),
              Text(amount.toString()),
              Text(equity.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
