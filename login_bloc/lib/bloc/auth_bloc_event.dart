part of 'auth_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

final class AuthLoginRequested extends AuthBlocEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}
