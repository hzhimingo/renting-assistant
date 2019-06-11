import 'package:flutter/material.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';
import 'package:renting_assistant/pages/find_house_fix.dart';
import 'package:renting_assistant/pages/search_result_page.dart';

class SearchPageAppBar extends StatefulWidget implements PreferredSizeWidget {
  final height = 56.0;

  @override
  State<SearchPageAppBar> createState() {
    return _SearchPageAppBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _SearchPageAppBarState extends State<SearchPageAppBar> {

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Container(
                alignment: Alignment.centerLeft,
                height: 35.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: TextField(
                  onEditingComplete: () {
                    if (_searchController.value.text != "") {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return SearchResultPage(_searchController.value.text);
                      }));
                    }
                  },
                  controller: _searchController,
                  cursorColor: Colors.grey[600],
                  autofocus: true,
                  style: TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "请输入小区、商圈、地铁",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18.0,
                      color: Colors.grey[600],
                    ),
                    suffixIcon: IconButton(
                      splashColor: Colors.white,
                      icon: Icon(
                        Icons.cancel,
                        size: 18.0,
                        color: Colors.grey[600],
                      ),
                      onPressed: ()=> _searchController.clear(),
                    ),
                    contentPadding: EdgeInsets.only(
                      top: 8.0,
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "取消",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
