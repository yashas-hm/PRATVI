import 'package:shared_preferences/shared_preferences.dart';
import 'package:pra_tvi_web/core/app_constants.dart';

class AppSharedPreferences{
  static late SharedPreferences _preferences;

  AppSharedPreferences(){
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async => _preferences = await SharedPreferences.getInstance();

  static set setLoggedIn(bool value) => _preferences.setBool(AppConstants.loginSP, value);

  static bool get getLoggedIn => _preferences.getBool(AppConstants.loginSP) ?? false;

  static set setLoginNumber(String value) => _preferences.setString(AppConstants.numberSP, value);

  static String get getLoginNumber => _preferences.getString(AppConstants.numberSP)!;
}