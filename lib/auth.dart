import 'package:emrals/data/database_helper.dart';

enum AuthState { LOGGED_IN, LOGGED_OUT }

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

  void dispose(AuthStateListener listener) {
    for (var l in _subscribers) {
      if (l == listener) _subscribers.remove(l);
    }
  }

  void notify(AuthState state) {
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }
}
