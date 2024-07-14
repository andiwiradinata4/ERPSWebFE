part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginAuthEvent extends AuthEvent {
  final String username, password;
  final Map<String, String>? queries;

  LoginAuthEvent(
      {required this.username, required this.password, this.queries});

  @override
  List<Object?> get props => [username, password];
}

class MeEvent extends AuthEvent {
  MeEvent();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordTokenEvent extends AuthEvent {
  final String email;

  ForgetPasswordTokenEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordEvent extends AuthEvent {
  final ResetPasswordEntity data;

  ResetPasswordEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class ChangePasswordEvent extends AuthEvent {
  final String currentPassword, newPassword;

  ChangePasswordEvent(
      {required this.currentPassword, required this.newPassword});

  @override
  List<Object?> get props => [currentPassword, newPassword];
}
