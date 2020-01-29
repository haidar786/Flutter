iOS Build Status: [![Build Status](https://app.bitrise.io/app/012ca4e62392dade/status.svg?token=4yOnk8UtsMDm3sLwcPYs-Q)](https://app.bitrise.io/app/012ca4e62392dade)

Android Build Status: [![Build Status](https://app.bitrise.io/app/3924b288464de0f5.svg?token=QPv4ax__CjGQ8DOjBz9X7g)](https://app.bitrise.io/app/3924b288464de0f5)

# Flutter

Emrals app in Flutter

## Getting Started

This project is a Flutter application.

A few resources to get you started:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.io/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

https://stackoverflow.com/questions/43916323/how-do-i-create-an-animated-number-counter
https://pub.dartlang.org/packages/qr_mobile_vision

files to translate:
buy
camera
ęontacts
home_screen
leaderboard
login_screen
profile
report_detail
report_list
send_btc
settings
signup_screen
zone_list
form_util
network_util

flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations.dart

edit lib/l10n/intl_zh.arb lib/l10n/intl_es.arb files

flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localizations.dart lib/l10n/intl_zh.arb lib/l10n/intl_es.arb
