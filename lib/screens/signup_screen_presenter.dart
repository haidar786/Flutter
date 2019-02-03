import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/user.dart';

abstract class SignupScreenContract {
  void onSignupSuccess(User user);
  void onSignupError(String errorTxt);
}

class SignupScreenPresenter {
  SignupScreenContract _view;
  RestDatasource api = new RestDatasource();
  SignupScreenPresenter(this._view);

  doSignup(String username, String email, String password) async {
    try {
      var user = await api.signup(username, email, password);
      _view.onSignupSuccess(user);
    } on Exception catch (error) {
      _view.onSignupError(error.toString());
    }
  }
}
