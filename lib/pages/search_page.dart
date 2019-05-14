import 'package:flutter/material.dart';
import 'package:renting_assistant/widgets/search_page_appbar.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchPageAppBar(),
      body: Center(
        child: Text('SearchPage'),
      ),
    );
  }

}