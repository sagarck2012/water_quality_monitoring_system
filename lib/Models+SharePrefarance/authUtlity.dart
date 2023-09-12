import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_quality_monitoring_system/Models+SharePrefarance/loginModel.dart';

class AuthUtility{

  AuthUtility._();

  static Future<void> saveUserInfo(loginModel model) async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.setString("user-data", model.toJson().toString());
  }

  static Future<void> saveToken(String Token) async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.setString("token", Token);
  }

  static Future<void> saveID(String ID) async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.setString("ID", ID);
  }

// -----------------------------------------------------

  static Future<loginModel> getUserInfo() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    String value =  _sharedPrefs.getString("user-data")!;
    return loginModel.fromJson(jsonDecode(value));
  }
  static Future<String> getToken() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    return _sharedPrefs.getString("token") ?? "";
  }

  static Future<String> getID() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    String value =  _sharedPrefs.getString("ID")!;
    return value;
  }


// -----------------------------------------------------

  static Future<void> clearUserInfo() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();
  }

// -----------------------------------------

  static Future<bool> checkIfUserLoggedIn() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    return _sharedPrefs.containsKey("user-data");
  }
  static Future<bool> checkToken() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    return _sharedPrefs.containsKey("token");
  }
  static Future<bool> checkID() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    return _sharedPrefs.containsKey("ID");
  }

}