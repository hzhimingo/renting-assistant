import 'package:renting_assistant/model/filter_condition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStore {

  static Future saveCurrentCity(String city) async {
    SharedPreferences preferences  = await SharedPreferences.getInstance();
    preferences.setString("current_city", city);
  }

  static Future clearCurrentCity() async {
    SharedPreferences preferences  = await SharedPreferences.getInstance();
    preferences.remove("current_city");
  }

  static Future<String> readCurrentCity() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentCity = preferences.get("current_city");
    return currentCity;
  }

  static Future saveCurrentGeo(String geo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("geo", geo);
  }

  static Future<String> readCurrentGeo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String geo = preferences.get("geo");
    return geo;
  }

  static Future<String> readDevServerAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String address = preferences.get("dev_server_address");
    return address;
  }

  static Future saveDevServerAddress(String devServerAddress) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("dev_server_address", devServerAddress);
  }

  static Future saveFilterCondition(FilterCondition condition) async {
    String conditionString = jsonEncode(condition);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("conditionString", conditionString);
  }

  static Future<FilterCondition> readFilterCondition() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FilterCondition condition = FilterCondition.fromMap(jsonDecode(preferences.get("conditionString")));
    return condition;
  }
}