import 'package:equatable/equatable.dart';
import 'package:erps/core/error/error_response_exception.dart';
import 'package:erps/core/models/token.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:erps/features/auth/domain/entities/v1/login_entity.dart';
import 'package:erps/features/auth/domain/services/v1/abs_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AbsAuthService _service;

  LoginBloc(this._service) : super(LoginUninitializedState()) {
    on<LoginAuthEvent>(_onLoginAuthEvent);
    on<MeEvent>(_onMeEvent);
  }

  void _onLoginAuthEvent(LoginAuthEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      Token token = await _service
          .login(LoginEntity(userName: event.username, password: event.password));
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

  void _onMeEvent(MeEvent event, Emitter<LoginState> emit) async {
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

  void _onForgetPasswordEvent(MeEvent event, Emitter<LoginState> emit) async {
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
}
