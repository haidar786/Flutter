import 'package:emrals/auth.dart';
import 'package:emrals/components/reveal_progress_button.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/localizations.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/empty_screen.dart';
import 'package:emrals/screens/login_screen_presenter.dart';
import 'package:emrals/state_container.dart';
import 'package:emrals/styles.dart';
import 'package:emrals/utils/form_util.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:emrals/localizations.dart';

class LoginScreen extends StatefulWidget {
  static const usernameFieldKey = Key('username_field');
  static const passwordFieldKey = Key('password_field');
  static const loginButtonKey = Key('login_button');
  final LoginScreenPresenter loginScreenPresenter;
  final bool isMock;

  const LoginScreen({Key key, this.loginScreenPresenter, this.isMock = false})
      : super(key: key);

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _password, _username;
  int buttonState = 0;

  LoginScreenPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = widget.loginScreenPresenter ?? LoginScreenPresenter();
    AuthStateProvider()..subscribe(this);
  }

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void onAuthStateChanged(AuthState state) {
    // Invoked when the AuthStateProvider is initialised
    if (state == AuthState.LOGGED_IN) {
      Navigator.of(_ctx).pushReplacementNamed('/home');
    }
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() {
      buttonState = 0;
    });
  }

  @override
  void onLoginSuccess(User user) async {
    //_showSnackBar('Logged in as ${user.username}');
    if (widget.isMock == false) {
      await DatabaseHelper().saveUser(user);
      StateContainer.of(_ctx).updateUser(user);
      StateContainer.of(context).refreshUser();
      await Navigator.of(_ctx).pushReplacementNamed('/home');
    } else {
      StateContainer.of(context).updateUser(user);
      await Navigator.of(_ctx).pushReplacement(
          MaterialPageRoute(builder: (context) => EmptyScreen()));
    }
  }

  void _submit(BuildContext context) async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      try {
        final User user = await _presenter.doLogin(_username, _password);
        this.onLoginSuccess(user);
      } on Exception catch (e) {
        this.onLoginError(e.toString());
      }
    } else {
      setState(() {
        buttonState = 0;
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    final _appLocalization = AppLocalizations.of(context);
    FormUtil _formUtil = FormUtil(appLocalizations: _appLocalization);
    var loginForm = Center(
      child: ListView(
        children: <Widget>[
          Image(image: AssetImage("assets/logo.png")),
          Center(
            child: Text(
              _appLocalization.rewardingCityCleanUp,
              textScaleFactor: 1,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              _appLocalization.versionApp,
              textScaleFactor: .9,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (val) => _username = val,
                    key: LoginScreen.usernameFieldKey,
                    validator: _formUtil.validateName,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: _appLocalization.userName,
                      labelStyle: TextStyle(
                        background: Paint()..color = Colors.white,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    onSaved: (val) => _password = val,
                    validator: _formUtil.validatePasswordEntered,
                    key: LoginScreen.passwordFieldKey,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: _appLocalization.password,
                      labelStyle: TextStyle(
                        background: Paint()..color = Colors.white,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      fillColor: Colors.white,
                      //border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Center(
              child: RevealProgressButton(
                key: LoginScreen.loginButtonKey,
                startColor: emralsColor(),
                endColor: Colors.green,
                name: _appLocalization.login,
                onPressed: () {
                  if (!mounted) return;
                  setState(() {
                    buttonState = 1;
                    _submit(context);
                  });
                },
                state: buttonState,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Center(
                child: Text(
                  _appLocalization.signUpHere,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Center(
                  child: Container(
                    height: 24,
                    child: Center(
                      child: Text(
                        _appLocalization.forgetPassword,
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () =>
                    launchURL('https://www.emrals.com/accounts/password/reset'),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: emralsColor(),
          image: DecorationImage(
            image: AssetImage("assets/citybg.png"),
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ClipRect(
            child: Container(
              child: loginForm,
              height: 450.0,
              width: 300.0,
            ),
          ),
        ),
      ),
    );
  }
}
