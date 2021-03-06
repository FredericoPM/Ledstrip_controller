
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionRepository{

  Future<String> loadStringData(String dataName) async{
    String value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    value = (prefs.getString(dataName) ?? '');
    return value;
  }
  Future<void> setStringData(String dataName, String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(dataName, value);
  }

}