import 'package:emrals/models/user.dart';
import 'package:emrals/screens/empty_screen.dart';
import 'package:emrals/screens/login_screen.dart';
import 'package:emrals/screens/login_screen_presenter.dart';
import 'package:emrals/state_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockLoginScreenPresenter extends Mock implements LoginScreenPresenter {
  @override
  Future<User> doLogin(String username, String password) {
    return Future.value(
        User('mockUsername', null, null, null, null, null, null));
  }
}

void main() {
  group('Login Screen navigation tests', () {
    MockNavigatorObserver mockObserver;
    MockLoginScreenPresenter loginScreenPresenter;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      loginScreenPresenter = MockLoginScreenPresenter();
    });

    Future<void> _buildLoginPage(WidgetTester tester) async {
      await tester.pumpWidget(
        StateContainer(
          child: MaterialApp(
            home: LoginScreen(
              loginScreenPresenter: loginScreenPresenter,
              isMock: true,
            ),
            //routes: routes,

            // This mocked observer will now receive all navigation events
            // that happen in our app.
            navigatorObservers: [mockObserver],
          ),
        ),
      );

      // The tester.pumpWidget() call above just built our app widget
      // and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    Future<void> _navigateToHomePage(WidgetTester tester) async {
      // Fills in the text fields
      await tester.enterText(
          find.byKey(LoginScreen.usernameFieldKey), 'validUsername');
      await tester.enterText(
          find.byKey(LoginScreen.passwordFieldKey), 'ValidPassword123!');

      // Presses the login button
      await tester.tap(find.byKey(LoginScreen.loginButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets('Successful login navigates to the home screen',
        (WidgetTester tester) async {
      await _buildLoginPage(tester);
      await _navigateToHomePage(tester);

      // Checks if we pushed to the home screen
      //verify(mockObserver.didPush(any, any));

      // Checks if the Home Screen is now in the widget tree
      expect(find.byType(EmptyScreen), findsOneWidget);
      //await tester.runAsync(() async {});
    });
  });
}
