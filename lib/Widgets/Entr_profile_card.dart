// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pbl2022_app/constants/size_constants.dart';
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
    return Align(
      alignment: Alignment.center,
      child: Expanded(
        child: AspectRatio(
          aspectRatio: 3 / 2.7,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: mediaQuery.size.height * (1 / 100),
              horizontal: mediaQuery.size.width * (1 / 100),
            ),
            // decoration: BoxDecoration(border: Border.all()),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    projectText(theme, mediaQuery),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: mediaQuery.size.width * (40 / 100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              descriptionText(theme),
                              SizedBox(
                                  height: mediaQuery.size.height * (2 / 100)),
                              askingPriceText(theme),
                              equityText(theme),
                            ],
                          ),
                        ),
                        SizedBox(width: mediaQuery.size.width * (2 / 100)),
                        SizedBox(
                          width: mediaQuery.size.width * (40 / 100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                  height: mediaQuery.size.height * (1 / 100)),
                              progressIndicator(context, mediaQuery),
                              SizedBox(
                                  height: mediaQuery.size.height * (1 / 100)),
                              ownerText(theme),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align ownerText(ThemeData theme) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Text(
          '~' + owner,
          textAlign: TextAlign.right,
          style: theme.textTheme.headline3,
        ),
      ),
    );
  }

  CircularPercentIndicator progressIndicator(
      BuildContext context, MediaQueryData mediaQuery) {
    return CircularPercentIndicator(
      radius: mediaQuery.size.width * (20 / 100),
      center: Text(
        (equity * 100).toStringAsFixed(2) + '%',
        maxLines: 1,
      ),
      percent: equity,
      fillColor: Theme.of(context).colorScheme.onSecondary,
      lineWidth: 45,
    );
  }

  Align equityText(ThemeData theme) {
    return Align(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Text(
          'Equity: ' + (equity * 100).toStringAsFixed(2) + '%',
          style: theme.textTheme.headline3,
          textAlign: TextAlign.left,
        ),
      ),
      alignment: Alignment.center,
    );
  }

  Align askingPriceText(ThemeData theme) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Ask: $askingPrice',
        style: theme.textTheme.headline3,
        textAlign: TextAlign.left,
      ),
    );
  }

  Align descriptionText(ThemeData theme) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        '"$description"',
        style: theme.textTheme.headline2,
        maxLines: 3,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  Align projectText(ThemeData theme, MediaQueryData mediaQuery) {
    return Align(
      alignment: Alignment(-1.0, -1.0),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: mediaQuery.size.height * (1 / 100)),
        child: Text(
          projName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headline1,
        ),
      ),
    );
  }
}
