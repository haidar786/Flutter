import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  RestDatasource api = RestDatasource();

  Future<User> doLogin(String username, String password) async {
    return api.login(username, password);
  }
}
