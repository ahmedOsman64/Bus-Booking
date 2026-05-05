import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'login': 'Login',
      'register': 'Register',
      'search': 'Search',
      'origin': 'Origin',
      'destination': 'Destination',
      'book_now': 'Book Now',
      'my_tickets': 'My Tickets',
    },
    'so': {
      'login': 'Soo Gal',
      'register': 'Is Diiwaan Gel',
      'search': 'Raadi',
      'origin': 'Halkaad Ka Timid',
      'destination': 'Halkaad Aadaysid',
      'book_now': 'Hada Boos Diiwaan Gel',
      'my_tickets': 'Tigidhadayda',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'so'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
