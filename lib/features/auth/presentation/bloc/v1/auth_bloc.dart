import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/error_response_exception.dart';
import '../../../../../core/models/pagination.dart';
import '../../../../../core/models/token.dart';
import '../../../data/models/user.dart';
import '../../../domain/entities/v1/login_entity.dart';
import '../../../domain/entities/v1/register_entity.dart';
import '../../../domain/entities/v1/reset_password_entity.dart';
import '../../../domain/entities/v1/verify_email_confirmation_entity.dart';
import '../../../domain/services/v1/abs_auth_service.dart';

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
    on<GetDetailEvent>(_onGetDetailEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<DeleteEvent>(_onDeleteEvent);
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

  void _onGetDetailEvent(GetDetailEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      User data = await _service.getDetail(event.id);
      emit(GetDetailSuccessState(data));
    } on ErrorResponseException catch (e) {
      emit(GetDetailErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  void _onRegisterEvent(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      Token data = await _service.register(event.data);

      /// For Register External User.
      // _service.login(LoginEntity(
      //     userName: event.data.userName, password: event.data.password));
      emit(RegisterSuccessState(data));
    } on ErrorResponseException catch (e) {
      emit(RegisterErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(RegisterErrorState(message: e.toString()));
    }
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      bool isSuccess = await _service.delete(event.id);
      emit(DeleteSuccessState(isSuccess));
    } on ErrorResponseException catch (e) {
      emit(DeleteErrorState(
          statusCode: e.statusCode,
          message: e.errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')));
    } catch (e) {
      emit(DeleteErrorState(message: e.toString()));
    }
  }
}
