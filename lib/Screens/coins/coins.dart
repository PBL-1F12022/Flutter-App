import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../constants/urls.dart';

class Coins extends StatefulWidget {
  const Coins({Key? key}) : super(key: key);
  static const routeName = '/coins_screen';

  @override
  State<Coins> createState() => _CoinsState();
}

class _CoinsState extends State<Coins> {
  final storage = const FlutterSecureStorage();
  int balance = 200;
  double buyAmount = 0;
  double sellAmount = 0;

  final TextEditingController _buyCoin = TextEditingController();
  final TextEditingController _sellCoin = TextEditingController();

  bool _load = true;
  late final type;
  Future getBalance() async {
    try {
      final String? type = await storage.read(key: 'userType');
      String? token = await storage.read(key: 'token');

      final response = await http.get(
        Uri.parse(coinsUrl + type! + "/balance"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        var coins = result['coins'];
        balance = coins as int;
        _load = false;
        setState(() {});
      } else {
        var result = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: result['msg'] ?? "Error",
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

  Future buyCoins(BuildContext context) async {
    try {
      Map data = {
        "coins": int.parse(_buyCoin.text.trim()),
      };
      final String? type = await storage.read(key: 'userType');
      final token = await storage.read(key: 'token');

      final response = await http.post(
        Uri.parse(coinsUrl + type! + "/buy"),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: result['msg'] ?? "Coins credited to account",
          backgroundColor: Colors.red.shade600,
        );
        balance += int.parse(_buyCoin.text.trim());
        setState(() {});
      } else {
        var result = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: result['msg'] ?? "Error while performing transaction",
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

  Future sellCoins(BuildContext context) async {
    try {
      Map data = {
        "coins": int.parse(_sellCoin.text.trim()),
      };
      final String? type = await storage.read(key: 'userType');
      final token = await storage.read(key: 'token');

      final response = await http.post(
        Uri.parse(coinsUrl + type! + "/sell"),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: result['msg'] ?? "Coins debited from account",
          backgroundColor: Colors.red.shade600,
        );
        balance -= int.parse(_sellCoin.text);
        setState(() {});
      } else {
        var result = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: result['msg'] ?? "Error while performing transaction",
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
    _load = true;
    getBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coin Portal"),
        centerTitle: true,
      ),
      body: _load
          ? const Center(
              child: CircularProgressIndicator(),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.height * 0.90,
                      height: size.width * 0.30,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 169, 0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Current Balance: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "₹ " + balance.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.height * 0.90,
                      height: size.width * 0.30,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 77, 207, 7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 155, 236, 123),
                                  ),
                                ),
                                onPressed: () async {
                                  await buyCoins(context);
                                  _buyCoin.clear();
                                },
                                child: const Text(
                                  "Buy",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  controller: _buyCoin,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "0",
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.height * 0.85,
                      height: size.width * 0.30,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 180, 33, 23),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 236, 147, 123),
                                  ),
                                ),
                                onPressed: () async {
                                  await sellCoins(context);
                                  _sellCoin.clear();
                                },
                                child: const Text(
                                  "Sell",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  controller: _sellCoin,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "0",
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
