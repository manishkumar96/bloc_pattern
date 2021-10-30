import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper{

  static Future<bool> putString(String keyName,String value) async{

final prefs = await SharedPreferences.getInstance();

return prefs.setString(keyName,value);

  }

  static Future<bool> putBoolean(String keyName, bool value) async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.setBool(keyName, value);
  }
}