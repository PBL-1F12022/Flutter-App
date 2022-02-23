// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/Screens/home_scr_investor.dart';
import 'package:pbl2022_app/constants/size_constants.dart';

import '../constants/urls.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup_screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _load = false;

  final storage = const FlutterSecureStorage();

  Future signUpInvestor(BuildContext context) async {
    try {
      Map data = {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
        "phone": _phoneController.text.trim()
      };

      final response = await http.post(
        Uri.parse(signUpInvestorUrl),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 201) {
        print(response.body);
        var result = jsonDecode(response.body);
        // await storage.write(key: 'token', value: result['token']);
        // await storage.write(key: 'name', value: _nameController.text.trim());
        // await storage.write(key: 'email', value: _emailController.text.trim());
        // await storage.write(key: 'id', value: result['user']['_id']);

        Fluttertoast.showToast(
          msg: 'sign-up successful',
          backgroundColor: Colors.red.shade600,
        );
        print('SignUp');
        setState(() {
          _load = false;
        });

        Navigator.of(context).pushNamed(HomeScreenInvestor.routeName);
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong! Try again later',
          backgroundColor: Colors.red.shade600,
        );
        setState(() {
          _load = false;
        });
      }
    } catch (e) {
      setState(() {
        _load = false;
      });
      Fluttertoast.showToast(
        msg: 'Please try again later',
        backgroundColor: Colors.red.shade600,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          height:
              SizeConfig.getProportionateScreenHeight(mediaQuery.size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'WELCOME!',
                style: theme.textTheme.headline1,
              ),
              Text(
                'Please sign up to continue...',
                style: theme.textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              // Image.asset(
              //   'assets/images/signup_image.jpg',
              //   height: 150,
              //   fit: BoxFit.cover,
              // ),
              // Image.network(
              //   'https://www.clipartmax.com/png/middle/437-4379862_signup-icon-signup-sign-up-icon.png',
              //   fit: BoxFit.cover,
              // ),
              Container(
                height: SizeConfig.getProportionateScreenHeight(370),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(
                  bottom: SizeConfig.getProportionateScreenHeight(150),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                      // bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          nameTextField(),
                          emailTextField(),
                          phNumberTextField(),
                          passwordField(),
                          _load
                              ? signupButtonLoad()
                              : signupButton(theme, context),
                          // TextButton(
                          //   onPressed: () {},
                          //   child: Text('Already a user?'),
                          // ),
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

  TextFormField passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        label: Text('Password'),
        icon: Icon(Icons.password),
      ),
    );
  }

  TextFormField phNumberTextField() {
    return TextFormField(
      controller: _phoneController,
      validator: (value) {
        if (value!.length != 10) {
          return 'Check again!';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          label: Text('Contact number'), icon: Icon(Icons.contact_phone)),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        label: Text('Email ID'),
        icon: Icon(Icons.email),
      ),
    );
  }

  TextFormField nameTextField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        label: Text('Name'),
        icon: Icon(Icons.text_fields),
      ),
    );
  }

  Container signupButton(ThemeData theme, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: MaterialButton(
        padding: EdgeInsets.all(10),
        color: theme.buttonTheme.colorScheme!.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          _load = true;
          if (_formKey.currentState!.validate()) {
            signUpInvestor(context);
          } else {
            setState(() {
              _load = false;
            });
          }
          _formKey.currentState!.save();
        },
        child: Text('Sign Up'),
      ),
    );
  }

  Container signupButtonLoad() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: CircularProgressIndicator(),
    );
  }
}
