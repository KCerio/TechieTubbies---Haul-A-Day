import 'package:shared_preferences/shared_preferences.dart';


class Shared {
  static String loginSharedPreference = "LOGGEDINKEY";
  static String staffIdSharedPreference = "STAFFIDKEY";

  static Future<bool> saveLoginSharedPreference(bool islogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(loginSharedPreference, islogin);
  }

  static Future<bool> saveStaffId(String staffId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(staffIdSharedPreference, staffId);
  }

  static Future<String?> getStaffId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(staffIdSharedPreference);
  }


}

