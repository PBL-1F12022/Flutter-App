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
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 200),
          padding: EdgeInsets.all(20),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text('Name'),
                          icon: Icon(Icons.text_fields),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text('Email ID'),
                          icon: Icon(Icons.email),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.length != 10) {
                            return 'Check again!';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            label: Text('Contact number'),
                            icon: Icon(Icons.contact_phone)),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text('Password'),
                          icon: Icon(Icons.password),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Something\'s wrong')));
                          }
                          _formKey.currentState!.save();
                        },
                        child: Text('Sign Up'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
