//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:emrals/auth.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/login/login_screen_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emrals/styles.dart';
//import 'package:flutter/services.dart';
//import 'package:get_version/get_version.dart';
// used https://gist.github.com/hvisser/b027af96f9c57f94cf430bbdae236da9 to get get_version working


class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}



class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {

  //String _platformVersion = 'Unknown';

  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password, _username;
  

  @override
  initState() {
    super.initState();
    //initPlatformState();

  }

LoginScreenPresenter _presenter;
	
	  LoginScreenState() {
	    _presenter = new LoginScreenPresenter(this);
	    var authStateProvider = new AuthStateProvider();
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
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/home");
  }


  @override
  Widget build(BuildContext context) {

    
    //getPackageInfo();
    //var asyncWidget;
    _ctx = context;
    var loginBtn = new RaisedButton(
      color: emralsColor(),
      disabledColor: emralsColor(),
      //highlightedBorderColor: Colors.blue,
      highlightColor: emralsColor().shade500,
      //splashColor: emralsColor().shade500,
      disabledTextColor: Colors.blue,
      textColor: Colors.white,
      // width: MediaQuery.of(context).size.width,
      onPressed: _submit,
      child: new Text("LOGIN"),
      shape: StadiumBorder(
        side: BorderSide(width: 2.0, color: Colors.white),
      ),
    );
    var loginForm = new Column(
      children: <Widget>[
        new Image(image: AssetImage("assets/logo.png")),
        new Text(
          "rewarding city cleanup",
          textScaleFactor: 1,
        ),
        SizedBox(
          height: 10,
        ),
        
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 1 ? "Please fill in a username." : null;
                  },
                  decoration: new InputDecoration(
                    filled: true,
                    labelText: "Username",
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
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(
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
        _isLoading ? new CircularProgressIndicator() : loginBtn,
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(_ctx).pushReplacementNamed("/signup");
          },
          child: Text(
            "SIGN UP HERE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        decoration: new BoxDecoration(
          color: emralsColor(),
          image: new DecorationImage(
            image: new AssetImage("assets/citybg.png"),
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: new Center(
          child: new ClipRect(
            //child: new BackdropFilter(
            //filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: new Container(
              child: loginForm,
              height: 400.0,
              width: 300.0,
              // decoration: new BoxDecoration(
              //     color: Colors.grey.shade200.withOpacity(0.5)),
            ),
            //),
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
    _showSnackBar("logged in as" + user.username);
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_picture', user.picture);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}
