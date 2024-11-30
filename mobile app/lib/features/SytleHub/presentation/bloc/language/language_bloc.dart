import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences sharedPreferences;
  final String key = 'language';

  LanguageBloc({
    required this.sharedPreferences,
  }) : super(const LanguageState()) {
    final locale = getLocale();

    on<ChangeLanguageEvent>((event, emit) {
      setLocale(event.locale);
      emit(state.copyWith(locale: event.locale));
    });
    add(ChangeLanguageEvent(locale: locale));
  }

  void setLocale(Locale locale) {
    sharedPreferences.setString(key, locale.languageCode);
  }

  Locale getLocale() {
    final languageCode = sharedPreferences.getString(key);
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return const Locale('en');
  }
}
