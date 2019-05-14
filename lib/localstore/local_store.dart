import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {

  static Future saveCurrentCity(String city) async {
    SharedPreferences preferences  = await SharedPreferences.getInstance();
    preferences.setString("current_city", city);
  }

  static Future<String> readCurrentCity() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentCity = preferences.get("current_city");
    return currentCity;
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
}