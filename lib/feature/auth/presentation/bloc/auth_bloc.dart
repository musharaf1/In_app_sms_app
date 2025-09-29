import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inapp_sms/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:inapp_sms/core/usecase/usecase.dart';
import 'package:inapp_sms/core/entities/user.dart';
import 'package:inapp_sms/feature/auth/domain/repository/usecases/current_user.dart';
import 'package:inapp_sms/feature/auth/domain/repository/usecases/user_sign_up.dart';
import '../../domain/repository/usecases/user_login.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _currentUser = currentUser,
       _userLogin = userLogin,
       _userSignUp = userSignUp,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => AuthLoading());

    on<AuthLogin>(_onAuthLogin);

    on<AuthSignUp>(_onAuthSignUp);

    on<AuthIsUserLoggedIn>(_authIsUserLoggedIn);
  }

  Future<void> _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold((l) {
      emit(AuthFailure(l.errorMessage));
    }, (user) => _emitAuthSuccess(user, emit));
  }

  FutureOr<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold((l) {
      emit(AuthFailure(l.errorMessage));
    }, (user) => _emitAuthSuccess(user, emit));
  }

  void _authIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold((l) {
      return emit(AuthFailure(l.errorMessage));
    }, (user) => _emitAuthSuccess(user, emit));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
