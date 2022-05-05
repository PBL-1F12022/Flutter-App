import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isToShow;
  const CustomAppBar({
    Key? key,
    required this.title,
    this.isToShow = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 255, 169, 0),
      automaticallyImplyLeading: true,
      centerTitle: true,
      titleSpacing: 0,
      elevation: 5,
      titleTextStyle: TextStyle(
        fontSize: 25,
      ),
      title: Text(title),
    );
  }
}
