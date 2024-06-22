part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginAuthEvent extends LoginEvent {
  final String username, password;
  final Map<String, String>? queries;

  LoginAuthEvent({required this.username, required this.password, this.queries});

  @override
  List<Object?> get props => [username, password];
}

class MeEvent extends LoginEvent {
  MeEvent();

  @override
  List<Object?> get props => [];
}
