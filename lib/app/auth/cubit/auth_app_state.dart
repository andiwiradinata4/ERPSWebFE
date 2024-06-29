part of 'auth_cubit.dart';

abstract class AuthAppState extends Equatable {
  const AuthAppState();
}

class Anonymous extends AuthAppState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthAppState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}
