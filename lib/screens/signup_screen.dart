// TODO: Show/hide password: https://stackoverflow.com/a/49125284/1762493
// TODO: Real form validations

// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:emrals/auth.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/signup_screen_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emrals/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupScreenState();
  }
}

class SignupScreenState extends State<SignupScreen>
    implements SignupScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  bool passwordVisible = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _password, _username, _email;

  SignupScreenPresenter _presenter;

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  SignupScreenState() {
    _presenter = SignupScreenPresenter(this);
    var authStateProviderSignup = AuthStateProvider();
    authStateProviderSignup.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doSignup(_username, _password, _email);
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
    var signupBtn = Container(
      padding: const EdgeInsets.all(10.0),
      child: RaisedButton(
        color: emralsColor().shade50,
        disabledColor: emralsColor(),
        highlightColor: emralsColor().shade500,
        disabledTextColor: emralsColor().shade500,
        textColor: Colors.white,
        onPressed: _submit,
        child: Text('SIGN UP'),
        shape: StadiumBorder(
          side: BorderSide(width: 2.0, color: Colors.white),
        ),
      ),
    );
    var signupForm = Column(
      children: <Widget>[
        Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 1
                        ? "Username must have atleast 1 chars"
                        : null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      size: 17.0,
                      semanticLabel: 'username sign up icon',
                    ),
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (val) => _email = val,
                  validator: (val) {
                    return val.length < 1
                        ? "Email must have atleast 1 chars"
                        : null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.mail,
                      size: 17.0,
                      semanticLabel: 'user sign up email icon',
                    ),
                    labelText: "Email",
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password = val,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 17.0,
                      semanticLabel: 'password sign up icon',
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible
                              ? passwordVisible = false
                              : passwordVisible = true;
                        });
                      },
                    ),
                    filled: true,
                    labelText: "Password",
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
                  ),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? CircularProgressIndicator() : signupBtn,
        InkWell(
          child: Text(
            "By signing up you agree to our Terms and Conditions",
            style: TextStyle(
                color: Colors.white, decoration: TextDecoration.underline),
          ),
          onTap: () => launchURL('https://www.emrals.com/terms/'),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: emralsColor().shade50,
        ),
        child: Center(
          child: Container(
            child: signupForm,
            height: 300.0,
            width: 300.0,
          ),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(title: Text('Stack with LayoutBuilder')),
    //   key: scaffoldKey,
    //   body: LayoutBuilder(
    //     builder: (context, constraints) => Stack(
    //           fit: StackFit.expand,
    //           children: <Widget>[
    //             // Material(color: Colors.yellowAccent),
    //             Positioned(
    //               top: 10,
    //               child: signupForm,
    //             ),
    //             Positioned(
    //               top: constraints.maxHeight,
    //               left: constraints.maxWidth,
    //               child: Container(),
    //             ),
    //           ],
    //         ),
    //   ),
    // );
  }

  @override
  void onSignupError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onSignupSuccess(User user) async {
    _showSnackBar("logged in as" + user.username);
    setState(() => _isLoading = false);
    var db = DatabaseHelper();
    await db.saveUser(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_picture', user.picture);
    Navigator.of(_ctx).pushReplacementNamed("/home");
  }
}
