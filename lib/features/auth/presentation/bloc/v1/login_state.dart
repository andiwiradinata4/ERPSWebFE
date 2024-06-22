part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginUninitializedState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends LoginState {
  final Token token;

  LoginSuccessState(this.token);

  @override
  List<Object?> get props => [token];
}

class SuccessGetDetailState extends LoginState {
  final User user;

  SuccessGetDetailState(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginErrorState extends LoginState {
  final int statusCode;
  final String message;

  LoginErrorState({this.statusCode = 0, required this.message});

  @override
  List<Object?> get props => [statusCode, message];
}
