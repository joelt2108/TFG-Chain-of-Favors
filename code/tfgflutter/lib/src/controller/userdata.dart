import 'package:shared_preferences/shared_preferences.dart';

class DataUser{
  static final DataUser _user = new DataUser._internal();

  factory DataUser() {
    return _user;
  }

  DataUser._internal();

  SharedPreferences prefs;

  initPrefs() async {
    this.prefs = await SharedPreferences.getInstance();
  }

  get token {
    return prefs.getString('token') ?? '';
  }

  set token(String value) {
    prefs.setString('token', value);
  }

  get email {
    return prefs.getString('email') ?? '';
  }

  set email(String value) {
    prefs.setString('email', value);
  }

  get name {
    return prefs.getString('name') ?? '';
    // return prefs.getString('token') ?? '';
  }




  set name(String value) {
    prefs.setString('name', value);
  }

  get getrefreshtoken {
    return prefs.getString('refreshtoken') ?? '';
    // return prefs.getString('token') ?? '';
  }

  set refreshtoken(String value) {
    prefs.setString('refreshtoken', value);
  }


}