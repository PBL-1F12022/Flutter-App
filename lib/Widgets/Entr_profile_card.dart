// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';

class EntrProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      width: double.infinity,
      height: (mediaQuery.size.height) * (17 / 100),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Project Name',
                style: theme.textTheme.headline1,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                '"Description Description Description Description Description Description  Description"',
                style: theme.textTheme.headline2,
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Ask'),
                Text('Total: ${10000}'),
              ],
            ),
            LinearPercentIndicator(
              lineHeight: 20,
              barRadius: Radius.circular(10),
              percent: 0.7,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '-Owner',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
