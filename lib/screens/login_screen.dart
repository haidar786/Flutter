//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:emrals/auth.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/login_screen_presenter.dart';
import 'package:emrals/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _password, _username;

  LoginScreenPresenter _presenter;

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  LoginScreenState() {
    _presenter = LoginScreenPresenter(this);
    var authStateProvider = AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = Container(
      padding: const EdgeInsets.all(10.0),
      child: RaisedButton(
        color: emralsColor(),
        disabledColor: emralsColor(),
        highlightColor: emralsColor().shade500,
        disabledTextColor: emralsColor().shade500,
        textColor: Colors.white,
        onPressed: _submit,
        child: Text("LOGIN"),
        shape: StadiumBorder(
          side: BorderSide(width: 2.0, color: Colors.white),
        ),
      ),
    );
    var loginForm = Column(
      children: <Widget>[
        Image(image: AssetImage("assets/logo.png")),
        Center(
          child: Text(
            "rewarding city cleanup",
            textScaleFactor: 1,
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
                  validator: (val) {
                    return val.length < 1 ? "Please fill in a username." : null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Username",
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
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Password",
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
        _isLoading ? CircularProgressIndicator() : loginBtn,
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: Center(
            child: Text(
              "SIGN UP HERE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: InkWell(
            child: Text(
              "Forgot password?",
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.underline),
            ),
            onTap: () =>
                launchURL('https://www.emrals.com/accounts/password/reset'),
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
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

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar("logged in as " + user.username);
    setState(() => _isLoading = false);
    var db = DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}
