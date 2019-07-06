import 'package:emrals/models/user.dart';
//import 'package:emrals/routes.dart';
import 'package:emrals/screens/empty_screen.dart';
//import 'package:emrals/screens/home_screen.dart';
import 'package:emrals/screens/signup_screen.dart';
import 'package:emrals/screens/signup_screen_presenter.dart';
import 'package:emrals/state_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockSignupScreenPresenter extends Mock implements SignupScreenPresenter {
  @override
  Future<dynamic> doSignup(String username, String email, String password) {
    return Future.value(
        User('mockUsername', null, null, null, null, null, null));
  }
}

void main() {
  group('Sign Up Screen navigation tests', () {
    MockNavigatorObserver mockObserver;
    MockSignupScreenPresenter signupScreenPresenter;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      signupScreenPresenter = MockSignupScreenPresenter();
    });

    Future<void> _buildSignUpPage(WidgetTester tester) async {
      await tester.pumpWidget(
        StateContainer(
          child: MaterialApp(
            home: SignupScreen(
              signupScreenPresenter: signupScreenPresenter,
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
          find.byKey(SignupScreen.usernameFieldKey), 'validUsername');
      await tester.enterText(
          find.byKey(SignupScreen.emailFieldKey), 'validemail@example.com');
      await tester.enterText(
          find.byKey(SignupScreen.passwordFieldKey), 'ValidPassword123!');

      // Presses the Sign Up button
      await tester.tap(find.byKey(SignupScreen.signUpButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets('Successful sign up navigates to the home screen',
        (WidgetTester tester) async {
      await _buildSignUpPage(tester);
      await _navigateToHomePage(tester);

      // Checks if we pushed to the home screen
      //verify(mockObserver.didPush(any, any));

      // Checks if the Home Screen is now in the widget tree
      expect(find.byType(EmptyScreen), findsOneWidget);
      //await tester.runAsync(() async {});
    });
  });
}
