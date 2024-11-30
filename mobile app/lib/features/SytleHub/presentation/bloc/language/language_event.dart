part of 'language_bloc.dart';

class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguageEvent extends LanguageEvent {
  final Locale locale;

  const ChangeLanguageEvent({required this.locale});

  @override
  List<Object> get props => [locale];
}
