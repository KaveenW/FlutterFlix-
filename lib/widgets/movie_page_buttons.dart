import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MoviePageButtons extends StatelessWidget {
  final Function onAddPressed;
  final Function onWatchedPressed;

  MoviePageButtons(
      {required this.onAddPressed, required this.onWatchedPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF292B37),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF292B37).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                )
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.white, size: 25),
              onPressed: onAddPressed as void Function()?,
            ),
          ),
          SizedBox(width: 30), // Add margin between the icons
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF292B37),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF292B37).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                )
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.remove_red_eye, color: Colors.white, size: 25),
              onPressed: onWatchedPressed as void Function()?,
            ),
          ),
        ],
      ),
    );
  }
}
