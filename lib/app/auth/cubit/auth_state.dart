part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class Anonymous extends AuthState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}
