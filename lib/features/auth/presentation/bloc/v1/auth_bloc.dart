import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:erps/core/error/error_response_exception.dart';
import 'package:erps/core/models/pagination.dart';
import 'package:erps/core/models/token.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:erps/features/auth/domain/entities/v1/login_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/reset_password_entity.dart';
import 'package:erps/features/auth/domain/entities/v1/verify_email_confirmation_entity.dart';
import 'package:erps/features/auth/domain/services/v1/abs_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AbsAuthService _service;

  AuthBloc(this._service) : super(LoginUninitializedState()) {
    on<LoginAuthEvent>(_onLoginAuthEvent);
    on<MeEvent>(_onMeEvent);
    on<ForgetPasswordTokenEvent>(_onForgetPasswordTokenEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
    on<EmailConfirmationTokenEvent>(_onEmailConfirmationTokenEvent);
    on<VerifyEmailConfirmationEvent>(_onVerifyEmailConfirmationEvent);
    on<ListDataEvent>(_onListDataEvent);
  }

  void _onLoginAuthEvent(LoginAuthEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      Token token = await _service.login(
          LoginEntity(userName: event.username, password: event.password));
      emit(LoginSuccessState(token));

      User user = await _service.me();
      emit(SuccessGetDetailState(user));
    } on ErrorResponseException catch (e) {
      emit(LoginErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  void _onMeEvent(MeEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      User user = await _service.me();
      emit(SuccessGetDetailState(user));
    } on ErrorResponseException catch (e) {
      emit(LoginErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  void _onForgetPasswordTokenEvent(
      ForgetPasswordTokenEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      Token token = await _service.resetPasswordToken(event.email);
      emit(ForgetPasswordTokenState(token));
    } on ErrorResponseException catch (e) {
      emit(LoginErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  void _onResetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      bool success = await _service.resetPassword(event.data);
      (success)
          ? emit(ResetPasswordSuccessState())
          : emit(ResetPasswordErrorState());
    } on ErrorResponseException catch (e) {
      emit(LoginErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  void _onChangePasswordEvent(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      bool success = await _service.changePassword(
          event.currentPassword, event.newPassword);
      (success)
          ? emit(ChangePasswordSuccessState())
          : emit(ChangePasswordErrorState());
    } on ErrorResponseException catch (e) {
      emit(LoginErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  void _onEmailConfirmationTokenEvent(
      EmailConfirmationTokenEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      Token token = await _service.emailConfirmationToken();
      emit(EmailConfirmationTokenState(token));
    } on ErrorResponseException catch (e) {
      emit(LoginErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  void _onVerifyEmailConfirmationEvent(
      VerifyEmailConfirmationEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      bool success = await _service.verifyEmailConfirmation(event.data);
      User user = await _service.me();
      (success)
          ? emit(VerifyEmailSuccessState(user))
          : emit(VerifyEmailErrorState());
    } on ErrorResponseException catch (e) {
      log(e.errors.values.join(","));
      emit(LoginErrorState(
          statusCode: e.statusCode,
          message: e.errors.values
              .join(",")
              .replaceAll("[", "")
              .replaceAll("]", "")));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  void _onListDataEvent(ListDataEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      Pagination<User> data = await _service.listData(event.queries);
      emit(ListDataSuccessState(data));
    } on ErrorResponseException catch (e) {
      emit(ListDataErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }
}
