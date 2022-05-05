import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/Widgets/appbar.dart';

import '../constants/urls.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const routeName = '/profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // bool _passwordVisible;
  bool _load = true;
  final storage = const FlutterSecureStorage();
  // TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController coinsController = TextEditingController();
  String name = 'USER';

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    coinsController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    String? token = await storage.read(key: 'token');
    String? type = await storage.read(key: 'userType');
    // token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MjZiZmYyNDNmOWE3ZWUyMjgyNGMwZjYiLCJpYXQiOjE2NTE0MDE4NjR9.1umKWOSv8rWIhJZbnVlJSpCEEuD3PqQscobZiA8r4_A";
    // type = "investor";

    if (token == null) {
      print("User not logged in");
    } else {
      try {
        Map<String, String> headers = {"Authorization": "Bearer $token"};
        final response = await http.get(
          Uri.parse(baseUrl + "/" + type! + "/me"),
          headers: headers,
        );
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          emailController.text = result['email'];
          usernameController.text = result['name'];
          name = result['name'];
          phoneController.text = result['phone'].toString();
          coinsController.text = result['coins'].toString();
          setState(() {
            _load = false;
          });
        } else {
          Fluttertoast.showToast(
            msg: 'Something went wrong please try again later!',
            backgroundColor: Colors.blue.shade600,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Something went wrong please try again later!',
          backgroundColor: Colors.blue.shade600,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'My Profile'),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.22), BlendMode.dstATop),
              image: const AssetImage("assets/images/background.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: _load == true
              ? const Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _headerOfProfile(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
                        child: _buildForm(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  _headerOfProfile() {
    return ClipPath(
      child: Container(
        height: 90,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // colors: [Color.fromARGB(255, 0, 41, 226), Color(0xff000000)],
            colors: [Color.fromARGB(255, 255, 169, 0), Color.fromARGB(255, 255, 206, 109)],
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30.0,
                backgroundImage: AssetImage("assets/images/signup_image.jpg"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        'Hello',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: usernameController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                validator: (String? value) {
                  if (value!.isEmpty) return 'username cannot be empty';
                  return null;
                },
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Username',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 169, 0),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                enabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: emailController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                validator: (String? value) {
                  if (value!.isEmpty) return 'Email cannot be empty';
                  return null;
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  isDense: true,
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 169, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                enabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: phoneController,
                validator: (String? value) {
                  if (value!.isEmpty) return 'Phone cannot be empty';
                  return null;
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  isDense: true,
                  labelText: 'Phone number',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 169, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                enabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: coinsController,
                validator: (String? value) {
                  if (value!.isEmpty) return 'College Name cannot be empty';
                  return null;
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  isDense: true,
                  labelText: 'Coins',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 169, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                enabled: false,
              ),
            ),
          ],
        ));
  }
}
