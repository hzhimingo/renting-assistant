import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/pages/home_page.dart';
import 'package:renting_assistant/pages/find_house_page.dart';
import 'package:renting_assistant/pages/InformationPage.dart';
import 'package:renting_assistant/pages/mine_page.dart';

import 'find_house_fix.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  Color _defaultColor = Colors.grey;
  Color _activateColor = Colors.cyan[300];

  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    _clearCurrentCity();
    _setDevAddress();
  }

  void _clearCurrentCity() async {
    await LocalStore.clearCurrentCity();
  }

  void _setDevAddress() async {
    await LocalStore.saveDevServerAddress("192.168.31.83");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        //禁止滑动
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: <Widget>[
          HomePage(),
          FindHouseFix(),
          InformationPage(),
          MinePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: _defaultColor),
              title: Text('首页'),
              activeIcon: Icon(Icons.home, color: _activateColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _defaultColor),
              title: Text('找房'),
              activeIcon: Icon(Icons.search, color: _activateColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment, color: _defaultColor),
              title: Text('社区'),
              activeIcon: Icon(
                Icons.comment,
                color: _activateColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: _defaultColor),
              title: Text('我的'),
              activeIcon: Icon(Icons.person, color: _activateColor))
        ],
      ),
    );
  }
}
