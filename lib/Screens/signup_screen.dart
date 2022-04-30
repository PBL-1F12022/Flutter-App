// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, constant_identifier_names

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

enum userType { Investor, Entrepreneur }
String dropDownValue = 'Investor';
String tokenString = "";

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    isUserLoggedIn();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _load = false;
  bool _isAutoLogin = false;

  final storage = FlutterSecureStorage();
  Future isUserLoggedIn() async {
    tokenString = (await storage.read(key: 'token'))!;
    final response = await http.get(Uri.parse(signUpInvestorUrl + tokenString));
    if (response.statusCode == 200) {
      setState(() {
        _isAutoLogin = true;
      });
    }
    print(response.statusCode);
  }

  Future loginUser(int index) async {
    try {
      final token = storage.read(key: 'token');
      Map data = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      };
      final url = (index == 0)
          ? Uri.parse(loginInvestorUrl)
          : Uri.parse(loginEntrepreneurUrl);
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
        },
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(context)
            .pushReplacementNamed(HomeScreenInvestor.routeName);
      } else {}
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong! Try again later',
        backgroundColor: Colors.red.shade600,
      );
    }
  }

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
        // print(response.body);
        var result = jsonDecode(response.body);
        await storage.write(key: 'token', value: result['token']);
        Fluttertoast.showToast(
          msg: 'sign-up successful',
          backgroundColor: Colors.red.shade600,
        );
        // print('SignUp');
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

  Future signUpEntrepreneur(BuildContext context) async {
    try {
      Map data = {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
        "phone": _phoneController.text.trim()
      };

      final response = await http.post(
        Uri.parse(signUpEntrepreneurUrl),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      // print(response.body);
      // print(response.statusCode.toString());

      if (response.statusCode == 201) {
        var result = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: 'sign-up successful',
          backgroundColor: Colors.red.shade600,
        );
        setState(() {
          _load = false;
        });
        print('Entrepreneur added');
        // storage.write(key: "LoginKey", value: );
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
    bool _isLogin = true;
    SizeConfig.init(context);
    final items = ['Investor', 'Entrepreneur'];
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    late final width = mediaQuery.size.width;
    late final height = mediaQuery.size.height;
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
              Container(
                height: SizeConfig.getProportionateScreenHeight(400),
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
                  child: _isLogin
                      ? Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Expanded(
                              child: Column(
                                children: <Widget>[
                                  emailTextField(),
                                  passwordField(),
                                  _load
                                      ? signupButtonLoad()
                                      : dropDownValue ==
                                              userType.Entrepreneur.name
                                          ? loginButton(
                                              theme,
                                              context,
                                              userType.Entrepreneur.index,
                                            )
                                          : loginButton(
                                              theme,
                                              context,
                                              userType.Investor.index,
                                            ),
                                  DropdownButton(
                                    value: dropDownValue,
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        child: Text(items),
                                        value: items,
                                      );
                                    }).toList(),
                                    icon: Icon(Icons.arrow_drop_down_circle),
                                    onChanged: (String? newVal) {
                                      setState(() {
                                        dropDownValue = newVal!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Expanded(
                              child: Column(
                                children: <Widget>[
                                  nameTextField(),
                                  emailTextField(),
                                  phNumberTextField(),
                                  passwordField(),
                                  _load
                                      ? signupButtonLoad()
                                      : dropDownValue ==
                                              userType.Entrepreneur.name
                                          ? signupButton(
                                              theme,
                                              context,
                                              userType.Entrepreneur.index,
                                            )
                                          : signupButton(
                                              theme,
                                              context,
                                              userType.Investor.index,
                                            ),
                                  // _load
                                  //     ? signupButtonLoad()
                                  //     : dropDownValue == userType.investor.name
                                  //         ? signupButton(
                                  //             theme,
                                  //             context,
                                  //             // userType.investor,
                                  //             1,
                                  //           )
                                  //         : signupButton(
                                  //             theme,
                                  //             context,
                                  //             // userType.entrepreneur,
                                  //             0,
                                  //           ),
                                  // TextButton(
                                  //   onPressed: () {},
                                  //   child: Text('Already a user?'),
                                  // ),
                                  DropdownButton(
                                    value: dropDownValue,
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        child: Text(items),
                                        value: items,
                                      );
                                    }).toList(),
                                    icon: Icon(Icons.arrow_drop_down_circle),
                                    onChanged: (String? newVal) {
                                      setState(() {
                                        dropDownValue = newVal!;
                                      });
                                    },
                                  ),
                                ],
                              ),
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

  Container loginButton(ThemeData theme, BuildContext context, int index) {
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
            loginUser(index);
            // (index == 0)
            // ? loginUser(index)
            // : signUpEntrepreneur(context);
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

  Container signupButton(
    ThemeData theme,
    BuildContext context,
    var userTypeName,
  ) {
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
            (userTypeName == 0)
                ? signUpInvestor(context)
                : signUpEntrepreneur(context);
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
