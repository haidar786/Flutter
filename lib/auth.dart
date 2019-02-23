import 'package:emrals/data/database_helper.dart';

enum AuthState { LOGGED_IN, LOGGED_OUT, AUTH_ERROR }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state);
}

class AuthStateProvider {
  static final AuthStateProvider _instance = AuthStateProvider.internal();

  List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;
  AuthStateProvider.internal() {
    _subscribers = List<AuthStateListener>();
    initState();
  }

  void initState() async {
    var db = DatabaseHelper();
    var isLoggedIn = await db.isLoggedIn();
    if (isLoggedIn)
      notify(AuthState.LOGGED_IN);
    else
      notify(AuthState.LOGGED_OUT);
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void unsubscribe(AuthStateListener listener) {
    _subscribers.remove(listener);
  }

  void dispose(AuthStateListener listener) {
    _subscribers.removeWhere((l) => l == listener);
  }

  void notify(AuthState state) {
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }
}
