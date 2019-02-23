import 'package:emrals/auth.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/auth_result_model.dart';
import 'package:emrals/models/user.dart';

class AuthApi {
  DatabaseHelper db = DatabaseHelper();
  RestDatasource api = RestDatasource();

  Future<AuthData> isAuthenticated() async {
    AuthData authData;
    bool isAuthenticated = await db.isLoggedIn();
    AuthState authState =
        isAuthenticated ? AuthState.LOGGED_IN : AuthState.LOGGED_OUT;
    authData = AuthData(authState: authState, errorString: null, user: null);
    return authData;
  }

  Future<AuthData> authenticate({String username, String password}) async {
    AuthData authData;
    User user;
    String authError;
    AuthState authState;
    try {
      user = await api.login(username, password);
      await db.saveUser(user);
    } on Exception catch (error) {
      authError = error.toString();
    }
    if (authError != null || user == null) {
      authState = AuthState.AUTH_ERROR;
    } else {
      authState = AuthState.LOGGED_IN;
    }
    authData = AuthData(
      user: user,
      errorString: authError,
      authState: authState,
    );
    return authData;
  }
}
