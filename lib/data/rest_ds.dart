import 'dart:async';
import 'dart:convert';

import 'package:emrals/utils/network_util.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/models/user_profile.dart';
import 'package:emrals/styles.dart';
import 'dart:math';

class RestDatasource {
  NetworkUtil _netUtil = NetworkUtil();
  static final baseURL = apiUrl;
  static final loginURL = baseURL + "login/";
  static final signupURL = baseURL + "rest-auth/registration/";
  static final tipURL = baseURL + "tip/";
  static final reportURL = baseURL + "alerts/";
  static final inviteURL = baseURL + "invite/";
  static final usersURL = baseURL + "users/";
  static final sendURL = baseURL + "send/";
  static final updateURL = baseURL + "me/";

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

  Future<dynamic> sendEmrals(double amount, String address, String token) {
    Map<String, dynamic> payload = {
      "amount": amount,
      "address": address,
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil
        .post(sendURL, headers: headers, body: json.encoder.convert(payload))
        .then((dynamic res) {
      return res;
    });
  }

  Future<dynamic> updateEmrals(String token) {
    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil.get(updateURL, headers).then((dynamic res) {
      return res;
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

  Future<dynamic> deleteReport(int reportID, String token) {
    Map<String, int> payload = {
      "report_id": reportID,
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil
        .delete(reportURL + "/" + reportID.toString() + "/",
            headers: headers, body: json.encoder.convert(payload))
        .then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      return res;
    });
  }

  Future<bool> inviteUser(String email, String token) async {
    Map<String, String> payload = {
      "email": email,
    };

    Map<String, String> headers = {
      "Authorization": "token $token",
      "Content-type": "application/json"
    };

    return _netUtil
        .post(inviteURL, headers: headers, body: json.encoder.convert(payload))
        .then((b) => true, onError: (e) => false);
  }

  Future<UserProfile> getUser(int id) async {
    return _netUtil.get(usersURL + id.toString() + "/").then((dynamic res) {
      if (res["error"] != null) {
        throw Exception(res["error"]);
      }
      return UserProfile.map(res);
    });
  }

  // The user is only passed to test that the current user's position is
  // correct and is highlighted properly.
  Future<List<User>> getAllUsers(User user) async {
    _netUtil.post(baseURL + "/leaderboard");
    await Future.delayed(Duration(seconds: 1));
    return List.generate(
        100,
        (i) => User(
            "User $i",
            "",
            Random().nextInt(1000).toDouble(),
            0,
            "https://madeworthy.com/wp-content/uploads/2015/01/gravatar-logo-512.jpg",
            0,
            ""))
      ..add(user);
  }
}
