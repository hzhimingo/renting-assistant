import 'package:flutter/material.dart';

class FindHouseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final height = 60.0;

  @override
  State<FindHouseAppBar> createState() {
    return _FindHouseAppBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _FindHouseAppBarState extends State<FindHouseAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0, bottom: 6.0),
        child: Column(
          children: <Widget>[
            Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed("/search"),
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      height: 35.0,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(40.0)),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            size: 18.0,
                            color: Colors.grey[500],
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "请输入小区、商圈、地铁",
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () => Navigator.of(context).pushNamed("/find_house_map"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
