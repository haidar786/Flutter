class FormUtil {
  String nameRegex = r'^.*(?=.{3,20})(?=.*[a-zA-Z ]*$)';
  String nameInvalidMessage = "Name must be 3-20 characters a-z and A-Z";
  String emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  String emailInvalidMessage = "Invalid Email";
  String passwordRegex =
      r'^.*(?=.{8,20})(?=.*[a-zA-Z])(?=.*\d)(?=.*[!#$%&? "]).*$';
  String passwordInvalidMessage = "8-20 letters, 1 number, 1 special character";

  String validateName(String value) =>
      validate(value, nameRegex, 'name', nameInvalidMessage);
  String validateEmail(String value) =>
      validate(value, emailRegex, 'email', emailInvalidMessage);
  String validatePassword(String value) =>
      validate(value, passwordRegex, 'password', passwordInvalidMessage);

  String validate(value, rule, name, warning) {
    RegExp regExp = new RegExp(rule);
    if (value.length == 0)
      return name + " is required";
    else if (!regExp.hasMatch(value)) return warning;
    return null;
  }
}
