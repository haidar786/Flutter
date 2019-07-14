class FormUtil {
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
      validate(value, notBlankRegex, 'password', passwordBlankMessage);
  String validateName(String value) =>
      validate(value, nameRegex, 'name', nameInvalidMessage);
  String validateEmail(String value) =>
      validate(value, emailRegex, 'email', emailInvalidMessage);
  String validatePassword(String value) =>
      validate(value, passwordRegex, 'password', passwordInvalidMessage);

  String validate(value, rule, name, warning) {
    RegExp regExp = new RegExp(rule);
    if (value.length == 0) {
      return "Please enter your " + name;
    } else if (!regExp.hasMatch(value)) return warning;

    return null;
  }
}
