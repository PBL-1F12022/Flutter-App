// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class EntrProfileCard extends StatelessWidget {
  late final String id;
  late final String projName;
  late final String description;
  late final int askingPrice;
  late final double equity;
  late final String owner;
  EntrProfileCard({
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
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
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
            projectText(theme),
            const SizedBox(height: 10),
            descriptionText(theme),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                askingPriceText(),
                equityText(),
              ],
            ),
            progressIndicator(context),
            ownerText(),
          ],
        ),
      ),
    );
  }

  Align ownerText() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(
        '~Owner',
        textAlign: TextAlign.right,
      ),
    );
  }

  LinearPercentIndicator progressIndicator(BuildContext context) {
    return LinearPercentIndicator(
      center: Text('$equity%'),
      lineHeight: 20,
      barRadius: Radius.circular(10),
      percent: equity / 100,
      fillColor: Theme.of(context).colorScheme.onSecondary,
    );
  }

  Text equityText() => Text('Total: $equity%');

  Text askingPriceText() => Text('Ask: $askingPrice');

  Align descriptionText(ThemeData theme) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        '"$description"',
        style: theme.textTheme.headline2,
        maxLines: 2,
        overflow: TextOverflow.clip,
      ),
    );
  }

  Align projectText(ThemeData theme) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        projName,
        style: theme.textTheme.headline1,
      ),
    );
  }
}
