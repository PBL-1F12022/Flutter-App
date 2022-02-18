// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EnterProfileCard extends StatelessWidget {
  late final String id;
  late final String projName;
  late final String description;
  late final int askingPrice;
  late final double equity;
  late final String owner;
  EnterProfileCard({
    this.askingPrice = 0,
    this.description = "",
    this.equity = 0,
    this.id = "",
    this.owner = "",
    this.projName = "",
  });
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      width: double.infinity,
      height: (mediaQuery.size.height) * (25 / 100),
      child: Card(
        elevation: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: (mediaQuery.size.width) * (50 / 100),
              child: Column(
                children: [
                  projectText(theme),
                  SizedBox(height: 25),
                  descriptionText(theme),
                  askingPriceText(theme),
                  equityText(theme),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  child: progressIndicator(context),
                  padding: EdgeInsets.all(13),
                ),
                ownerText(theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Align ownerText(ThemeData theme) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          '~Owner',
          textAlign: TextAlign.right,
          style: theme.textTheme.headline3,
        ),
      ),
    );
  }

  CircularPercentIndicator progressIndicator(BuildContext context) {
    return CircularPercentIndicator(
      radius: 90,
      center: Text(
        '$equity%',
        maxLines: 1,
      ),
      percent: equity / 100,
      fillColor: Theme.of(context).colorScheme.onSecondary,
      lineWidth: 45,
    );
  }

  Align equityText(ThemeData theme) {
    return Align(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Total: $equity%',
          style: theme.textTheme.headline3,
          textAlign: TextAlign.left,
        ),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Align askingPriceText(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Ask: $askingPrice',
          style: theme.textTheme.headline3,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Align descriptionText(ThemeData theme) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          '"$description"',
          style: theme.textTheme.headline2,
          maxLines: 3,
          softWrap: true,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Align projectText(ThemeData theme) {
    return Align(
      alignment: Alignment(-1.0, -1.0),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          projName,
          style: theme.textTheme.headline1,
        ),
      ),
    );
  }
}
