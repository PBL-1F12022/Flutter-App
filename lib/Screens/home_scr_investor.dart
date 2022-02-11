// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pbl2022_app/Widgets/Entr_profile_card.dart';

class HomeScreenInvestor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home scr Inv'),
      ),
      body: EntrProfileCard(),
    );
  }
}
