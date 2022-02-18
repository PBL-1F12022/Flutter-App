// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:pbl2022_app/constants/size_constants.dart';

class SignupScreen extends StatelessWidget {
  static const routeName = '/signup_screen';
  final _formKey = GlobalKey<FormState>();

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
                          signupButton(theme, context),
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
      obscureText: true,
      decoration: InputDecoration(
        label: Text('Password'),
        icon: Icon(Icons.password),
      ),
    );
  }

  TextFormField phNumberTextField() {
    return TextFormField(
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
      decoration: InputDecoration(
        label: Text('Email ID'),
        icon: Icon(Icons.email),
      ),
    );
  }

  TextFormField nameTextField() {
    return TextFormField(
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
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Something\'s wrong')));
          }
          _formKey.currentState!.save();
        },
        child: Text('Sign Up'),
      ),
    );
  }
}
