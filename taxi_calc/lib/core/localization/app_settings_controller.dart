import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, bosnian, german }

extension AppLanguageX on AppLanguage {
  Locale get locale {
    switch (this) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.bosnian:
        return const Locale('bs');
      case AppLanguage.german:
        return const Locale('de');
    }
  }

  String get label {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.bosnian:
        return 'Bosanski';
      case AppLanguage.german:
        return 'Deutsch';
    }
  }

  static AppLanguage fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'bs':
        return AppLanguage.bosnian;
      case 'de':
        return AppLanguage.german;
      case 'en':
      default:
        return AppLanguage.english;
    }
  }
}

class AppSettingsController extends ChangeNotifier {
  static const String _languageCodeKey = 'language_code';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  AppLanguage get language => AppLanguageX.fromLocale(_locale);

  Future<void> loadSavedLanguage() async {
    String? languageCode;
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final prefs = await SharedPreferences.getInstance();
        languageCode = prefs.getString(_languageCodeKey);
        break;
      } on PlatformException {
        if (attempt == 2) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 150));
      } on MissingPluginException {
        if (attempt == 2) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 150));
      }
    }

    if (languageCode == null || languageCode.isEmpty) {
      return;
    }

    final loaded = Locale(languageCode);
    if (loaded == _locale) {
      return;
    }

    _locale = loaded;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    final newLocale = language.locale;
    if (newLocale == _locale) {
      return;
    }

    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageCodeKey, _locale.languageCode);
    } on PlatformException {
      return;
    } on MissingPluginException {
      return;
    }
  }
}
