import 'package:caco_flutter_blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:caco_flutter_blog/core/usecase/usecase.dart';
import 'package:caco_flutter_blog/core/common/entities/user.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/current_user.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/user_logIn.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/user_signOut.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/user_signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignUp;
  final UserLogin _userLogIn;
  final UserSignOut _userSignOut;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignup userSignUp,
    required UserLogin userLogIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserSignOut userSignOut,
    })  : _userSignUp = userSignUp, 
          _userLogIn = userLogIn,
          _userSignOut = userSignOut,
          _currentUser = currentUser,
          _appUserCubit = appUserCubit,
          super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)), 
      (r) => _emitAuthSuccess(r, emit),
      );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _userSignUp(
      UserSignUpParams(
        username: event.username,
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _userLogIn(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _userSignOut(NoParams());
      _appUserCubit.updateUser(null);
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _emitAuthSuccess(
    User user, 
    Emitter<AuthState> emit
    ) {
      _appUserCubit.updateUser(user);
      emit(AuthSuccess(user));
  }
}
