import 'package:emrals/utils/field_validator.dart';
import 'package:test/test.dart';

void main() {
  test('empty value returns error string', () {
    var actual = FieldValidator.validate(name: '_', value: '');
    expect(actual, 'Please fill in a _.');
  });

  test('password with less than 8 characters returns error string', () {
    var actual = FieldValidator.validatePassword('1234567');
    expect(actual, FieldValidator.INVALID_PASSWORD_MESSAGE);
  });

  test('empty username returns error string', () {
    var actual = FieldValidator.validateUsername('');
    expect(actual, FieldValidator.INVALID_USERNAME_MESSAGE);
  });

  test('empty email returns error string', () {
    var actual = FieldValidator.validateEmail('');
    expect(actual, FieldValidator.EMPTY_EMAIL_MESSAGE);
  });
}
