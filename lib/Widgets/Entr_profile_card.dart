// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl2022_app/constants/size_constants.dart';
import 'package:pbl2022_app/constants/urls.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EnterProfileCard extends StatefulWidget {
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
  State<EnterProfileCard> createState() => _EnterProfileCardState();
}

class _EnterProfileCardState extends State<EnterProfileCard> {
  bool _isBookMarked = false;

  Future _toggleBookMark() async {
    final url = Uri.parse(bookmarkUrl);
    final response = await http.post(
      url,
      body: {
        'bookmark': widget.id.toString(),
      },
    );
    print(response.body);
    setState(() {
      _isBookMarked = true;
    });
  }

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
                    IconButton(
                      onPressed: () {
                        _toggleBookMark();
                      },
                      icon: _isBookMarked
                          ? Icon(
                              Icons.bookmark_add,
                            )
                          : Icon(
                              Icons.bookmark_add_outlined,
                            ),
                    ),
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
          '~' + widget.owner,
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
        (widget.equity * 100).toStringAsFixed(2) + '%',
        maxLines: 1,
      ),
      percent: widget.equity,
      fillColor: Theme.of(context).colorScheme.onSecondary,
      lineWidth: 45,
    );
  }

  Align equityText(ThemeData theme) {
    return Align(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Text(
          'Equity: ' + (widget.equity * 100).toStringAsFixed(2) + '%',
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
        'Ask: ${widget.askingPrice}',
        style: theme.textTheme.headline3,
        textAlign: TextAlign.left,
      ),
    );
  }

  Align descriptionText(ThemeData theme) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        '"${widget.description}"',
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
          widget.projName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headline1,
        ),
      ),
    );
  }
}

