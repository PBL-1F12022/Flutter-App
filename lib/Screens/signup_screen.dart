// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  static const routeName = '/signup_screen';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(label: Text('Name')),
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Email ID')),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.length != 10) {
                        return 'Check again!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(label: Text('Contact number')),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(label: Text('Password')),
                  ),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Something\'s wrong')));
                        }
                        _formKey.currentState!.save();
                      },
                      child: Text('Sign Up'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
