import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TempFindHouse extends StatefulWidget {
  @override
  State<TempFindHouse> createState() {
    return TempFindHouseState();
  }

}

class TempFindHouseState extends State<TempFindHouse> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Padding(
        padding: const EdgeInsets.all(4.0),
        child: new StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: 8,
          itemBuilder: (BuildContext context, int index) => new Container(
              color: Colors.green,
              child: new Center(
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Text('$index'),
                ),
              )),
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 3 : 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      height: 100.0,
      color: Colors.cyan,
      child: Center(
        child: Text("hello"),
      ),
    );
  }

}
