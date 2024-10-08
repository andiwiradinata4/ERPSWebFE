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

class EmailConfirmationTokenEvent extends AuthEvent {
  EmailConfirmationTokenEvent();

  @override
  List<Object?> get props => [];
}

class VerifyEmailConfirmationEvent extends AuthEvent {
  final VerifyEmailConfirmationEntity data;

  VerifyEmailConfirmationEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class ListDataEvent extends AuthEvent {
  final Map<String, String>? queries;

  ListDataEvent({this.queries});

  @override
  List<Object?> get props => [queries];
}

class GetDetailEvent extends AuthEvent {
  final String id;

  GetDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class RegisterEvent extends AuthEvent {
  final RegisterEntity data;

  RegisterEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class DeleteEvent extends AuthEvent {
  final String id;

  DeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}