//import 'dart:ui';

import 'package:emrals/bloc_provider.dart';
import 'package:emrals/bloc_providers/auth_api.dart';
import 'package:emrals/blocs/login_bloc.dart';
import 'package:emrals/components/reveal_progress_button.dart';
import 'package:emrals/models/auth_result_model.dart';
import 'package:flutter/material.dart';
import 'package:emrals/auth.dart';
import 'package:emrals/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:emrals/utils/field_validator.dart';

class LoginScreenBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      child: LoginScreen(),
      builder: (_, bloc) => bloc ?? LoginBloc(AuthApi()),
      onDispose: (_, bloc) => bloc.dispose(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _password, _username;
  int buttonState = 0;

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _submit(BuildContext context) {
    final loginBloc = Provider.of<LoginBloc>(context);
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      loginBloc.authenticate(username: _username, password: _password);
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
    final loginBloc = Provider.of<LoginBloc>(context);

    loginBloc.authDataStream.listen((AuthData authData) {
      switch (authData.authState) {
        case AuthState.LOGGED_IN:
          {
            _showSnackBar('Logged in as ${authData.user.username}');
            Navigator.of(context).pushReplacementNamed("/home");
          }
          break;
        case AuthState.AUTH_ERROR:
          {
            _showSnackBar(authData.errorString);
            setState(() {
              buttonState = 0;
            });
          }
          break;
        default:
          {}
      }
    });

    var loginForm = Column(
      children: <Widget>[
        Image(image: AssetImage("assets/logo.png")),
        Center(
          child: Text(
            "rewarding cleanup",
            textScaleFactor: 1,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "Version APP_VERSION_NUMBER (BUILD_NUMBER)",
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
                  key: new Key('username'),
                  validator: (val) =>
                      FieldValidator.validate(name: 'username', value: val),
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Username",
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
                  validator: (val) =>
                      FieldValidator.validate(name: 'password', value: val),
                  key: new Key('password'),
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Password",
                    labelStyle: new TextStyle(
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
              startColor: emralsColor(),
              endColor: Colors.green,
              name: 'LOGIN',
              onPressed: () {
                if (!mounted) return;
                setState(() {
                  print('Signup button pressed');
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
}
