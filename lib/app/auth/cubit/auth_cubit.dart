import 'package:equatable/equatable.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(Anonymous());

  Future<void> setAsAuthenticated(User user) async {
    emit(Authenticated(user));
  }

  Future<void> setAsAnonymous() async {
    emit(Anonymous());
  }
}
