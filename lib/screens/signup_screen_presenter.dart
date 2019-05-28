import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/user.dart';

abstract class SignupScreenContract {
  void onSignupSuccess(User user);
  void onSignupError(String errorTxt);
}

class SignupScreenPresenter {
  final RestDatasource api = RestDatasource();

  Future<dynamic> doSignup(
      String username, String email, String password) async {
    try {
      User user = await api.signup(username, password, email);
      return user;
    } on Exception catch (error) {
      return error.toString();
    }
  }
}
