// import 'package:emrals/screens/login_screen.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
//import 'package:emrals/utils/network_util.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AuthMock {
  AuthMock({this.userId});
  String userId;

  bool didRequestSignIn = false;
  bool didRequestCreateUser = false;
  bool didRequestLogout = false;

  Future<String> signIn(String email, String password) async {
    didRequestSignIn = true;
    return _userIdOrError();
  }

  Future<String> createUser(String email, String password) async {
    didRequestCreateUser = true;
    return _userIdOrError();
  }

  Future<String> currentUser() async {
    return _userIdOrError();
  }

  Future<void> signOut() async {
    didRequestLogout = true;
    return Future.value();
  }

  Future<String> _userIdOrError() {
    if (userId != null) {
      return Future.value(userId);
    } else {
      throw StateError('No user');
    }
  }
}

class ApiProvider {
  Client client = Client();
  // fetchPosts() async {
  //   final response = await client.get("https://jsonplaceholder.typicode.com/posts/1");
  //   ItemModel itemModel = ItemModel.fromJson(json.decode(response.body));
  //   return itemModel;
  // }
}

void main() {
  // Widget buildTestableWidget(Widget widget) {
  //   return MaterialApp(home: widget);
  // }

  // testWidgets('empty email and password doesn\'t call sign in',
  //     (WidgetTester tester) async {

  //   await tester.pumpWidget(buildTestableWidget(LoginScreen()));
  //   final loginBtn = find.text('LOGIN');
  //   expect(loginBtn, findsOneWidget);
  //   await tester.tap(loginBtn);
  // });

  test("Testing the network call", () {
    //setup the test
    //final apiProvider = NetworkUtil();
    final apiProvider = ApiProvider();
    apiProvider.client = MockClient((request) async {
      final mapJson = {'id': 123};
      return Response(json.encode(mapJson), 200);
    });
  });
}
