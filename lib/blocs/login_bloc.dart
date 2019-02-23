import 'dart:async';

import 'package:emrals/bloc_providers/auth_api.dart';
import 'package:emrals/models/auth_result_model.dart';

class LoginBloc {
  final AuthApi authApi;

  StreamController<AuthData> _authData = StreamController<AuthData>.broadcast();
  Stream<AuthData> get authDataStream => _authData.stream;

  LoginBloc(this.authApi) {
    authApi.isAuthenticated().then(_authData.add);
  }

  void authenticate({String username, String password}) {
    authApi
        .authenticate(username: username, password: password)
        .then(_authData.add);
  }

  void dispose() {
    _authData.close();
  }
}
