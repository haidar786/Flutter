import 'package:emrals/components/reveal_progress_button.dart';
import 'package:emrals/utils/field_validator.dart';
import 'package:flutter/material.dart';
import 'package:emrals/auth.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart' show User;
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

  bool passwordVisible = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _password, _username, _email;
  int buttonState = 0;

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
      form.save();
      _presenter.doSignup(_username, _password, _email);
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
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var signupForm = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  autofocus: true,
                  autocorrect: false,
                  onSaved: (val) => _username = val,
                  validator: FieldValidator.validateUsername,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      size: 17.0,
                      semanticLabel: 'username sign up icon',
                    ),
                    filled: true,
                    labelText: 'Username',
                    labelStyle: new TextStyle(
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (val) => _email = val,
                  validator: FieldValidator.validateEmail,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.mail,
                      size: 17.0,
                      semanticLabel: 'user sign up email icon',
                    ),
                    labelText: 'Email',
                    labelStyle: new TextStyle(
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autocorrect: false,
                  maxLength: 20,
                  obscureText: passwordVisible,
                  onSaved: (val) => _password = val,
                  validator: FieldValidator.validatePassword,
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
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    filled: true,
                    labelText: 'Password',
                    labelStyle: new TextStyle(
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
            startColor: emralsColor().shade50,
            endColor: Colors.green,
            name: 'SIGN UP',
            onPressed: () {
              print('Signup button pressed');
              setState(() {
                buttonState = 1;
                _submit();
              });
            },
            state: buttonState,
          )),
        ),
        InkWell(
          child: Text.rich(
            TextSpan(
              text:
                  'By signing up you agree to our', // default text style'By signing up you agree to our \n Terms and Conditions',
              style: TextStyle(color: Colors.white),
              children: <TextSpan>[
                TextSpan(
                    text: '\nTerms and Conditions ',
                    style: TextStyle(decoration: TextDecoration.underline)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          onTap: () => launchURL('https://www.emrals.com/terms/'),
        ),
      ],
      //crossAxisAlignment: CrossAxisAlignment.stretch,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Emrals Signup')),
      key: scaffoldKey,
      backgroundColor: emralsColor().shade50,
      body: Center(
        child: Container(
          width: 300,
          child: signupForm,
        ),
      ),
    );
  }

  @override
  void onSignupError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() {
      buttonState = 0;
    });
  }

  @override
  void onSignupSuccess(User user) async {
    _showSnackBar("logged in as" + user.username);
    var db = DatabaseHelper();
    await db.saveUser(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_picture', user.picture);
    Navigator.of(_ctx).pushReplacementNamed('/home');
  }
}
