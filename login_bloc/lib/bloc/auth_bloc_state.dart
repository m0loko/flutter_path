part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSucces extends AuthState {}

final class AuthFailed extends AuthState {
  final String error;

  AuthFailed(this.error);
}
