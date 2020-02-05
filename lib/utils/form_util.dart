import 'package:emrals/localizations.dart';
import 'package:flutter/material.dart';

class FormUtil {
  final AppLocalizations appLocalizations;
  FormUtil({@required this.appLocalizations});
  String nameRegex = r'^.*(?=.{3,20})(?=.*[a-zA-Z ]*$)';
  String notBlankRegex = r'^(?!\s*$).+';
  String passwordBlankMessage = "Please enter your password";
  String nameInvalidMessage = "Please enter 3-20 upper or lowercase characters";
  String emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  String emailInvalidMessage = "Please enter a valid email address";
  String passwordRegex =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,200}$';
  String passwordInvalidMessage =
      "8-200 letters, 1 number, 1 special character";


  String validatePasswordEntered(String value) =>
      validate(value, notBlankRegex, 'password', appLocalizations.enterYourPassword);
  String validateName(String value) =>
      validate(value, nameRegex, 'name', appLocalizations.nameInvalidMessage);
  String validateEmail(String value) =>
      validate(value, emailRegex, 'email', appLocalizations.emailInvalidMessage);
  String validatePassword(String value) =>
      validate(value, passwordRegex, 'password', appLocalizations.passwordInvalidMessage);

  String validate(value, rule, name, warning) {
    RegExp regExp = new RegExp(rule);
    if (value.length == 0) {
      return appLocalizations.pleaseEnterYour+" " + name;
    } else if (!regExp.hasMatch(value)) return warning;

    return null;
  }
}
