part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginUninitializedState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends AuthState {
  final Token token;

  LoginSuccessState(this.token);

  @override
  List<Object?> get props => [token];
}

class SuccessGetDetailState extends AuthState {
  final User user;

  SuccessGetDetailState(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginErrorState extends AuthState {
  final int statusCode;
  final String message;

  LoginErrorState({this.statusCode = 0, required this.message});

  @override
  List<Object?> get props => [statusCode, message];
}

class ForgetPasswordTokenState extends AuthState {
  final Token token;

  ForgetPasswordTokenState(this.token);

  @override
  List<Object?> get props => [token];
}

class ResetPasswordSuccessState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ResetPasswordErrorState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordSuccessState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordErrorState extends AuthState {
  @override
  List<Object?> get props => [];
}

class EmailConfirmationTokenState extends AuthState {
  final Token token;

  EmailConfirmationTokenState(this.token);

  @override
  List<Object?> get props => [token];
}

class VerifyEmailSuccessState extends AuthState {
  final User user;

  VerifyEmailSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class VerifyEmailErrorState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ListDataSuccessState extends AuthState {
  final Pagination<User> data;

  ListDataSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ListDataErrorState extends AuthState {
  final int statusCode;
  final String message;

  ListDataErrorState({this.statusCode = 0, required this.message});

  @override
  List<Object?> get props => [statusCode, message];
}
