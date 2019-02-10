import 'dart:async';
import 'dart:convert';

import 'package:emrals/utils/network_util.dart';
import 'package:emrals/models/user.dart';

class RestDatasource {
  NetworkUtil _netUtil = NetworkUtil();
  static final baseURL = "https://www.emrals.com/api/";
  static final loginURL = baseURL + "login/";
  static final signupURL = baseURL + "rest-auth/registration/";
  static final tipURL = baseURL + "tip/";

  Future<User> login(String username, String password) {
    return _netUtil.post(loginURL, body: {
      "username": username,
      "password": password,
    }).then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      return User.map(res);
    });
  }

  Future<User> signup(String username, String password, String email) {
    return _netUtil.post(signupURL, body: {
      "username": username,
      "email": email,
      "password1": password,
      "password2": password
    }).then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      if (res["email"] != null) {
        throw Exception(res["email"]);
      }
      if (res["username"] != null) {
        if (res["id"] == null) {
          throw Exception(res["username"]);
        }
      }
      if (res["password1"] != null) {
        throw Exception(res["password1"]);
      }

      return User.map(res);
    });
  }

  Future<dynamic> tipReport(int amount, int reportID, String token) {
    Map<String, int> payload = {
      "amount": amount,
      "report_id": reportID,
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil
        .post(tipURL, headers: headers, body: json.encoder.convert(payload))
        .then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      return res;
    });
  }
}
