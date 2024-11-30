part of 'theme_bloc.dart';

class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;

  const ChangeThemeEvent({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

class TemporaryThemeEvent extends ThemeEvent {
  final bool isDarkMode;
  const TemporaryThemeEvent({
    required this.isDarkMode,
  });

  @override
  List<Object> get props => [];
}
