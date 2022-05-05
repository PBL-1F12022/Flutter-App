// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/Screens/drawers.dart';
import 'package:pbl2022_app/Screens/home_scr_entrepreneur.dart';

import 'package:pbl2022_app/Screens/home_scr_investor.dart';
import 'package:pbl2022_app/constants/size_constants.dart';
import '../constants/urls.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup_screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

enum _userType { Investor, Entrepreneur }
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
  bool _isLogin = false;
  bool _isProcessing = true;

  final storage = FlutterSecureStorage();
  Future isUserLoggedIn() async {
    try {
      String? tokenString = await storage.read(key: 'token');
      String? userType = await storage.read(key: 'userType');
      if (tokenString != null) {
        setState(() {
          _isAutoLogin = true;
          _isProcessing = false;
        });
      } else {
        setState(() {
          _isAutoLogin = false;
          _isProcessing = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future loginUser(int index) async {
    try {
      setState(() {
        _load = true;
      });
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
        var result = jsonDecode(response.body);
        await storage.write(key: 'token', value: result['token']);
        await storage.write(
          key: 'userType',
          value: index == 0 ? 'investor' : 'entrepreneur',
        );
        if (index == 0) {
          Navigator.of(context)
              .pushReplacementNamed(HomeScreenInvestor.routeName);
        } else {
          Navigator.of(context)
              .pushReplacementNamed(HomeScreenEntrepreneur.routeName);
        }
      } else {
        setState(() {
          _load = false;
        });
        Fluttertoast.showToast(
          msg: 'Invalid credentials',
          backgroundColor: Colors.red.shade600,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong! Try again later',
        backgroundColor: Colors.red.shade600,
      );
    }
  }

  Future signUpInvestor(BuildContext context) async {
    try {
      setState(() {
        _load = true;
      });
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
      // print(response.statusCode);
      if (response.statusCode == 201) {
        // print(response.body);
        var result = jsonDecode(response.body);
        await storage.write(
            key: 'password', value: _passwordController.text.trim());
        await storage.write(key: 'token', value: result['token']);
        await storage.write(key: 'userType', value: 'investor');

        Fluttertoast.showToast(
          msg: 'sign-up successful',
          backgroundColor: Colors.red.shade600,
        );
        // print('SignUp');
        setState(() {
          _load = false;
        });
        while (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        Navigator.of(context)
            .pushReplacementNamed(HomeScreenInvestor.routeName);
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
      setState(() {
        _load = true;
      });
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
        // print('Entrepreneur added');
        final data = jsonDecode(response.body);
        // await storage.write(key: 'index', value: '2');
        // await storage.write(key: 'email', value: data['keyValue']['email']);
        // await storage.write(
        //     key: 'password', value: _passwordController.text.trim());
        await storage.write(key: 'userType', value: 'entrepreneur');

        Navigator.of(context)
            .pushReplacementNamed(HomeScreenEntrepreneur.routeName);
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
    final items = ['Investor', 'Entrepreneur'];
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    late final width = mediaQuery.size.width;
    late final height = mediaQuery.size.height;
    return _isProcessing
        ? Center(child: CircularProgressIndicator())
        : _isAutoLogin
            ? HomeScreenInvestor()
            // ? MyDrawer()
            : Scaffold(
                backgroundColor: Color(0xff292C31),
                body: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: height * (15 / 100)),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height * (1 / 100),
                                ),
                                Text(
                                  _isLogin ? 'LOG IN' : 'SIGN UP',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffA9DED8),
                                  ),
                                ),
                                SizedBox(),
                                Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        if (!_isLogin)
                                          textComponent(
                                            height,
                                            width,
                                            false,
                                            false,
                                            false,
                                            Icons.account_circle_outlined,
                                            'Name',
                                            _nameController,
                                          ),
                                        SizedBox(height: height * (2 / 100)),
                                        textComponent(
                                          height,
                                          width,
                                          false,
                                          true,
                                          false,
                                          Icons.email_outlined,
                                          'Email',
                                          _emailController,
                                        ),
                                        SizedBox(height: height * (2 / 100)),
                                        if (!_isLogin)
                                          textComponent(
                                            height,
                                            width,
                                            false,
                                            false,
                                            true,
                                            Icons.phone,
                                            'Phone number',
                                            _phoneController,
                                          ),
                                        SizedBox(height: height * (2 / 100)),
                                        textComponent(
                                          height,
                                          width,
                                          true,
                                          false,
                                          false,
                                          Icons.password_outlined,
                                          'Password',
                                          _passwordController,
                                        ),
                                        SizedBox(height: height * (2 / 100)),
                                      ],
                                    )),
                                DropdownButton(
                                  value: dropDownValue,
                                  dropdownColor: Color(0xff292C31),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        items,
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 17,
                                        ),
                                      ),
                                      value: items,
                                    );
                                  }).toList(),
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle,
                                    color: Colors.white60,
                                  ),
                                  onChanged: (String? newVal) {
                                    setState(() {
                                      dropDownValue = newVal!;
                                    });
                                  },
                                ),
                                _load
                                    ? signupButtonLoad()
                                    : _isLogin
                                        ? dropDownValue ==
                                                _userType.Investor.name
                                            ? loginButton(
                                                theme, context, 0, _isLogin)
                                            : loginButton(
                                                theme, context, 1, _isLogin)
                                        : dropDownValue ==
                                                _userType.Entrepreneur.name
                                            ? signupButton(
                                                theme,
                                                context,
                                                _userType.Entrepreneur.index,
                                              )
                                            : signupButton(
                                                theme,
                                                context,
                                                _userType.Investor.index,
                                              ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: !_isLogin
                                      ? Text(
                                          'Already a user?',
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 20,
                                          ),
                                        )
                                      : Text(
                                          'New user?',
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 20,
                                          ),
                                        ),
                                ),
                                SizedBox(height: height * (10 / 100)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  Container textComponent(
    double height,
    double width,
    bool isPassword,
    bool isEmail,
    bool isPhone,
    IconData icon,
    String hintText,
    TextEditingController controller,
  ) {
    return Container(
      height: width / 8,
      width: width / 1.21,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: width / 30),
      decoration: BoxDecoration(
        color: Color(0xff212428),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (isPhone) {
            if (value!.length != 10) {
              return 'Check again!';
            }
          }
          return null;
        },
        style: TextStyle(color: Colors.white.withOpacity(.9)),
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(.7),
          ),
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(.5),
          ),
        ),
      ),
    );
  }

  Container loginButton(
      ThemeData theme, BuildContext context, int index, bool isLogin) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: MaterialButton(
        padding: EdgeInsets.all(10),
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          _load = true;
          if (_formKey.currentState!.validate()) {
            loginUser(index);
          } else {
            setState(() {
              _load = false;
            });
          }
          _formKey.currentState!.save();
        },
        child: !isLogin
            ? Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        color: Colors.black,
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
        child: !_isLogin
            ? Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
