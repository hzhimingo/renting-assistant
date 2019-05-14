import 'package:flutter/material.dart';
import 'package:renting_assistant/pages/city_select_custom_header.dart';

class CitySelectPage extends StatefulWidget {

  @override
  State<CitySelectPage> createState() {
    return _CitySelectPageState();
  }

}

class _CitySelectPageState extends State<CitySelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
              icon: Icon(Icons.close, color: Colors.grey,),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          title: Text('选择城市', style: TextStyle(color: Colors.black),),
          centerTitle: true
      ),
      body: CitySelectCustomHeaderRoute(),
    );
  }

}