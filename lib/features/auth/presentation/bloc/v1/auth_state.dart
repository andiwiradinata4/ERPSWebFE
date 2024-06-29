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
