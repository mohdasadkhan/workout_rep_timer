part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();
  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}
class ThemeLoading extends ThemeState {}
class ThemeLoaded extends ThemeState {
  final AppThemeMode mode;
  const ThemeLoaded({required this.mode});
  @override
  List<Object> get props => [mode];
}
class ThemeError extends ThemeState {
  final String message;
  const ThemeError({required this.message});
}