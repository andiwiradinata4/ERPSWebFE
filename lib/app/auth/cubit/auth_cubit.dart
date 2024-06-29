import 'package:equatable/equatable.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_app_state.dart';

class AuthCubit extends Cubit<AuthAppState> {
  AuthCubit() : super(Anonymous());

  Future<void> setAsAuthenticated(User user) async {
    emit(Authenticated(user));
  }

  Future<void> setAsAnonymous() async {
    emit(Anonymous());
  }
}
