import 'package:emrals/utils/form_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FormUtil _formUtil = new FormUtil();

  test('password with less than 8 characters returns error string', () {
    var actual = _formUtil.validatePassword('1234567');
    expect(actual, _formUtil.passwordInvalidMessage);
  });

  test('password without a special character returns error string', () {
    var actual = _formUtil.validatePassword('password123');
    expect(actual, _formUtil.passwordInvalidMessage);
  });

  test('password without a number returns error string', () {
    var actual = _formUtil.validatePassword('password!!!');
    expect(actual, _formUtil.passwordInvalidMessage);
  });

  test('empty username returns error string', () {
    var actual = _formUtil.validateName(' ');
    expect(actual, _formUtil.nameInvalidMessage);
  });

  test('invalid email', () {
    var actual = _formUtil.validateEmail('abcd');
    expect(actual, _formUtil.emailInvalidMessage);
  });
}
