import 'package:flutter/material.dart';

class EditInformation extends StatefulWidget {
  @override
  _EditInformationState createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('填写问题，不超过60个字'),
      ),
    );
  }
}
