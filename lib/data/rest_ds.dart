import 'dart:async';

import 'package:emrals/utils/network_util.dart';
import 'package:emrals/models/user.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseURL = "https://www.emrals.com/api/";
  static final loginURL = baseURL + "login/";
  static final signupURL = baseURL + "rest-auth/registration/";

  Future<User> login(String username, String password) {
    return _netUtil.post(loginURL, body: {
      "username": username,
      "password": password
    }).then((dynamic res) {
      if(res["error"] != null){
        throw new Exception(res["error"]);
      } 
      return new User.map(res);
    });
  }

  Future<User> signup(String username, String password, String email) {
    return _netUtil.post(signupURL, body: {
      "username": username,
      "email": email,
      "password1": password,
      "password2": password
    }).then((dynamic res) {


        if(res["error"] != null){
          throw new Exception(res["error"]);
        } 
        if(res["email"] != null){
          throw new Exception(res["email"]);
        } 
        if(res["username"] != null){
          if(res["id"] == null){
            throw new Exception(res["username"]);
          }
        } 
        if(res["password1"] != null){
          throw new Exception(res["password1"]);
        } 



      return new User.map(res);
    });
  }

}