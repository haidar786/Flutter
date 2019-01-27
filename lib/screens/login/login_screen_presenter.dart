import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) async {

    try{
      var user = await api.login(username, password);
      _view.onLoginSuccess(user);
    } on Exception catch(error){
      _view.onLoginError(error.toString());
    }
  }
}