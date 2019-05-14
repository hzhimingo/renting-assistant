import 'package:flutter/material.dart';

class HouseInfoTag extends StatelessWidget {
  final String tagContent;
  final Color tagColor;
  final Color backgroundColor;

  HouseInfoTag({Key key, this.tagContent, this.tagColor, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      margin: EdgeInsets.only(left: 2.0, right: 2.0),
      child: Text(
        tagContent,
        style: TextStyle(
          fontSize: 10.0,
          color: tagColor,
          /*fontWeight: FontWeight.bold*/
        ),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(2.0)
      ),
    );
  }
}
