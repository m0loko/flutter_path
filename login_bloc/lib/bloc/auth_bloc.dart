import 'package:bloc/bloc.dart';
import 'package:flutter/physics.dart';
import 'package:meta/meta.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) {
      final email = event.email;
      final password = event.password;
      if (password.length < 6) {
        emit(AuthFailed('Password cannot be <6 characters'));
        return;
      }
      
    });
  }
}
