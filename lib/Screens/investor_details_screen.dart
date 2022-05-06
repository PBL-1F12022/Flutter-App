// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/constants/urls.dart';

// ignore: must_be_immutable
class InvestorDetails extends StatefulWidget {
  String id = '';

  InvestorDetails({Key? key, required this.id}) : super(key: key);
  static const routeName = '/investor_details_screen';

  @override
  State<InvestorDetails> createState() => _InvestorDetailsState();
}

class _InvestorDetailsState extends State<InvestorDetails> {
  List data = [];
  List investors = [];
  List finalData = [];
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
        setState(() {
          data = jsonDecode(response.body);
          for (var map in data) {
            if (map['_id'] == widget.id) {
              investors.add(map);
            }
          }
          finalData = investors[0]['investorDetails'];
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Investors List'),
      ),
      body: !_isLoaded
          ? Center(child: CircularProgressIndicator())
          : finalData.isEmpty
              ? Center(
                  child: Text(
                    'No investors yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.black,
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage("assets/images/background.jpg"),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.8), BlendMode.darken),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: finalData.length,
                    itemBuilder: (context, index) {
                      return InvestorCard(
                        height: height,
                        name: finalData[index]['name'],
                        amount: finalData[index]['amount'],
                        equity: finalData[index]['equity'],
                      );
                    },
                  ),
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
        aspectRatio: 3 / 0.9,
        child: Card(
          color: Color.fromARGB(32, 255, 255, 255),
          elevation: 10,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: " + name,
                  // name + " has invested",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  "Amount: " + amount.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  "Equity: " + equity.toStringAsFixed(4),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
