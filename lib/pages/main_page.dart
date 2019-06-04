import 'package:flutter/material.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/filter_condition.dart';
import 'package:renting_assistant/pages/home_page.dart';
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
    _setDevAddress();
    _initFilterCondition();
  }

  void _clearCurrentCity() async {
    await LocalStore.clearCurrentCity();
  }

  void _setDevAddress() async {
    await LocalStore.saveDevServerAddress("192.168.31.83");
  }

  _initFilterCondition() async {
    FilterCondition condition = FilterCondition();
    LocalStore.saveFilterCondition(condition);
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
              icon: Icon(IconData(0xe630, fontFamily: 'iconfont'),
                  color: _defaultColor),
              title: Text('首页'),
              activeIcon: Icon(IconData(0xe630, fontFamily: 'iconfont'),
                  color: _activateColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _defaultColor),
              title: Text('找房'),
              activeIcon: Icon(Icons.search, color: _activateColor)),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe7d5, fontFamily: 'iconfont'),
                color: _defaultColor),
            title: Text('社区'),
            activeIcon: Icon(
              IconData(0xe7d5, fontFamily: 'iconfont'),
              color: _activateColor,
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(IconData(0xe612, fontFamily: 'iconfont'), color: _defaultColor),
              title: Text('我的'),
              activeIcon: Icon(IconData(0xe612, fontFamily: 'iconfont'), color: _activateColor))
        ],
      ),
    );
  }
}
