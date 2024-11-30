import 'dart:ui';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('am'),
  ];

  static String getFlag(String languageCode) {
    switch (languageCode) {
      case 'am':
        return '🇪🇹 Amharic';
      case 'en':
        return '🇺🇸 English';
      default:
        return '🇪🇹 Amharic';
    }
  }
}
