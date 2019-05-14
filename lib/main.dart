import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renting_assistant/pages/dev_info_page.dart';
import 'package:renting_assistant/pages/find_house_page.dart';
import 'package:renting_assistant/pages/home_page.dart';
import 'package:renting_assistant/pages/main_page.dart';
import 'package:renting_assistant/pages/search_page.dart';
import 'package:renting_assistant/pages/setting_page.dart';
import 'package:renting_assistant/pages/sign_in_page.dart';
import 'package:renting_assistant/pages/temp_find_house.dart';

// entry of application
void main() {
  runApp(RentingAssistantApp());
  //去除状态栏的半透明
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent, statusBarIconBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class RentingAssistantApp extends StatefulWidget {
  @override
  State<RentingAssistantApp> createState() {
    return RentingAssistantAppState();
  }
}

class RentingAssistantAppState extends State<RentingAssistantApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder> {
        "/home": (BuildContext context) => new HomePage(),
        "/search": (BuildContext context) => new SearchPage(),
        "/findHouse": (BuildContext context) => new FindHousePage(),
        "/sign-in": (BuildContext context) => new SignInPage(),
        "/setting": (BuildContext context) => new SettingPage(),
        "/dev-info": (BuildContext context) => new DevInfoPage(),
        "/temp-info": (BuildContext context) => new TempFindHouse(),
      },
      theme: ThemeData(
        primaryColor: Colors.cyan[300]
      ),
      home: MainPage()
    );
  }
}

