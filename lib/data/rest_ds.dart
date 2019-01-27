import 'dart:async';

import 'package:emrals/utils/network_util.dart';
import 'package:emrals/models/user.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://www.emrals.com/api/";
  static final LOGIN_URL = BASE_URL + "login/";

  Future<User> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "password": password
    }).then((dynamic res) {
      if(res["error"] != null){
        throw new Exception(res["error"]);
      } 
      return new User.map(res);
    });
  }
}