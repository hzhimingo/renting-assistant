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
      body: ListView(
        children: <Widget>[
          /*ListTile(
            leading: Icon(Icons.history, size: 20.0,),
            title: Text('天鹅湾', style: TextStyle(fontSize: 14.0,),),
            trailing: IconButton(
              icon: Icon(Icons.delete, size: 20.0,),
              onPressed: () {},
            ),
          ),*/
        ],
      ),
    );
  }
}

class SearchResultPage extends StatefulWidget {
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

