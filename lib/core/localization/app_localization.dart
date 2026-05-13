import 'dart:convert';

import 'package:dhani_communications/core/local_storages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization extends ChangeNotifier {
  AppLocalization._();

  static final AppLocalization instance = AppLocalization._();

  static const String defaultLanguageCode = 'en';

  String _languageCode = defaultLanguageCode;
  Map<String, String> _strings = {};

  String get languageCode => _languageCode;

  Future<void> load([String? languageCode]) async {
    final savedLanguageCode = await LocalStorage.getLanguageCode();
    final nextLanguageCode = languageCode ??
        (savedLanguageCode.isNotEmpty ? savedLanguageCode : defaultLanguageCode);
    _languageCode = nextLanguageCode;
    final jsonString = await rootBundle.loadString(
      'assets/languages/$nextLanguageCode.json',
    );
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    _strings = decoded.map((key, value) => MapEntry(key, value.toString()));
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    await LocalStorage.saveLanguageCode(languageCode);
    await load(languageCode);
  }

  String translate(String key) => _strings[key] ?? key;
}

class AppLocalizationScope extends InheritedNotifier<AppLocalization> {
  const AppLocalizationScope({
    super.key,
    required AppLocalization localization,
    required super.child,
  }) : super(notifier: localization);

  static AppLocalization of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppLocalizationScope>();
    return scope?.notifier ?? AppLocalization.instance;
  }
}

extension AppLocalizationX on BuildContext {
  String tr(String key) => AppLocalizationScope.of(this).translate(key);

  String trParams(String key, Map<String, Object?> params) {
    var translated = tr(key);
    params.forEach((name, value) {
      translated = translated.replaceAll('{$name}', value?.toString() ?? '');
    });
    return translated;
  }
}
