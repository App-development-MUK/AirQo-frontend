import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomLocalizations {
  CustomLocalizations(this.locale);
  final Locale locale;

  static CustomLocalizations? of(BuildContext context) {
    return Localizations.of<CustomLocalizations>(context, CustomLocalizations);
  }

  static Map<String, Map<String, String>> _resources = {
    'en': {'title': 'Airqo', 'message': 'English'},
    'lg': {
      'title': 'Airqó',
      'message': 'Luganda',
    },
  };
  String? get title {
    return _resources[locale.languageCode]!['title'];
  }

  String? get message {
    return _resources[locale.languageCode]!['message'];
  }
}

class CustomLocalizationsDelegate
    extends LocalizationsDelegate<CustomLocalizations> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'lg'].contains(locale.languageCode);

  @override
  Future<CustomLocalizations> load(Locale locale) {
    return SynchronousFuture<CustomLocalizations>(CustomLocalizations(locale));
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}
