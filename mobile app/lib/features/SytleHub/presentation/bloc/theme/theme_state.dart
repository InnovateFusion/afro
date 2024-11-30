part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final ThemeMode temporary;

  const ThemeState({this.themeMode = ThemeMode.system, this.temporary = ThemeMode.system});

  @override
  List<Object> get props => [themeMode, temporary];

  ThemeState copyWith({ThemeMode? themeMode, ThemeMode? temporary}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      temporary: temporary ?? this.temporary,
    );
  }
}
