import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  @override
  State<InformationPage> createState() {
    return InformationPageState();
  }
}

class InformationPageState extends State<InformationPage> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('InformationPage'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}