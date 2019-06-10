import 'package:renting_assistant/model/filter_condition.dart';
import 'package:renting_assistant/model/user_info.dart';
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

  static Future saveAccessToken(String accessToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("accessToken", accessToken);
  }

  static Future<String> readAccessToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String accessToken = preferences.get("accessToken");
    return accessToken;
  }

  static Future removeAccessToken() async {
    print('remove');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("accessToken");
  }

  static Future saveUserInfo(UserInfo userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String json = jsonEncode(userInfo);
    preferences.setString("userInfo", json);
  }

  static Future<UserInfo> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get("userInfo") != null ? UserInfo.fromJson(jsonDecode(preferences.get("userInfo"))) : null;
  }

  static Future saveJpushId(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString("jpushId", id);
  }

  static Future removeUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("userInfo");
  }

  static Future removeJpushId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("jpushId");
  }

  static Future<String> readJpushId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("jpushId");
  }

  static Future saveKeyWords(String keyword) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await readKeywords().then((value) {
      if (value == null) {
        List<String> keywords = [];
        keywords.add(keyword);
        preferences.setStringList("keywords", keywords);
      } else {
        value.add(keyword);
        preferences.setStringList("keywords", value);
      }
    });
  }

  static Future<List<String>> readKeywords() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList("keywords");
  }
}