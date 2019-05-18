import 'package:flutter/material.dart';

class FilterTag extends StatefulWidget {
  final String filterTag;

  FilterTag(this.filterTag);

  @override
  _FilterTagState createState() => _FilterTagState();
}

class _FilterTagState extends State<FilterTag> {
  bool isActivate = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LimitedBox(
        child: Container(
          child: Text(
            widget.filterTag,
            style: TextStyle(color: isActivate ? Colors.cyan[400] : Colors.black),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isActivate ? Colors.cyan[200] : Colors.grey[300],
            ),
            borderRadius: BorderRadius.circular(
              15.0,
            ),
            color: isActivate ? Colors.cyan[100] : Colors.white,
          ),
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            left: 4.0,
            right: 4.0,
          ),
          padding: EdgeInsets.only(
            top: 4.0,
            bottom: 4.0,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          isActivate = !isActivate;
        });
      },
    );
  }
}