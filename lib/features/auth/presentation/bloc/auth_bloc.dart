import 'package:caco_flutter_blog/core/usecase/usecase.dart';
import 'package:caco_flutter_blog/features/auth/domain/entities/user.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/current_user.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/user_logIn.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/user_signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignUp;
  final UserLogin _userLogIn;
  final CurrentUser _currentUser;
  AuthBloc({
    required UserSignup userSignUp,
    required UserLogin userLogIn,
    required CurrentUser currentUser
    }) : _userSignUp = userSignUp, 
          _userLogIn = userLogIn,
          _currentUser = currentUser,
          super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)), 
      (r) {
        print(r.id);
        emit(AuthSuccess(r));
        }
      );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _userSignUp(
      UserSignUpParams(
        username: event.username,
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _userLogIn(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
