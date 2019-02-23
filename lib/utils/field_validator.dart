import 'package:flutter/material.dart';

class FieldValidator {
  static const String INVALID_PASSWORD_MESSAGE =
      'Password must be 8+ characters.';
  static const String INVALID_USERNAME_MESSAGE =
      'Username must contain at least 1 character';
  static const String EMPTY_EMAIL_MESSAGE =
      'Email must contain at least 1 character';
  static const String INVALID_EMAIL_MESSAGE = 'Email is invalid';

  static String validate({@required String name, @required String value}) {
    return value.isEmpty ? 'Please fill in a $name.' : null;
  }

  static String validatePassword(String password) {
    return password.length < 8 ? INVALID_PASSWORD_MESSAGE : null;
  }

  static String validateUsername(String username) {
    return username.isEmpty ? INVALID_USERNAME_MESSAGE : null;
  }

  static String validateEmail(String email) {
    if (email.isEmpty) {
      return EMPTY_EMAIL_MESSAGE;
    }
    bool validEmail = RegExp(
            r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(email);
    if (validEmail == false) {
      return INVALID_EMAIL_MESSAGE;
    }
    return null;
  }
}
