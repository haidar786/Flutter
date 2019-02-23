import 'package:emrals/auth.dart';
import 'package:emrals/models/user.dart';

class AuthData {
  final User user;
  final String errorString;
  final AuthState authState;

  AuthData({this.user, this.errorString, this.authState});
}
