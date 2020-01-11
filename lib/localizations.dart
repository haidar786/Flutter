import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message('Hello world App',
        name: 'title', desc: 'The application title');
  }

  String get hello {
    return Intl.message('Hello', name: 'hello');
  }

  String get reportTrash {
    return Intl.message('Report Trash');
  }

  String get reportTrashAnywhere {
    return Intl.message("Report trash from anywhere in the world");
  }

  String get cleanItUp {
    return Intl.message("Clean it up");
  }

  String get cleanItUpAndPost {
    return Intl.message("Clean it up and post a picture");
  }

  String get earnMoney {
    return Intl.message("Earn MONEY!");
  }

  String get earnMoneyCleaning {
    return Intl.message("Earn MONEY when your cleanup is verified");
  }

  String get letsGo {
    return Intl.message("Lets Go!");
  }

  String get language {
    return Intl.message("Language");
  }

  String get rewardingCleanup {
    return Intl.message("rewarding cleanup");
  }
  
  String get signUpHere {
    return Intl.message("SIGN UP HERE");
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
