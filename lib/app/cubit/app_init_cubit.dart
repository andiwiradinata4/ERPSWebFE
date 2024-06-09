// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_init_state.dart';

class AppInitCubit extends Cubit<AppInitState> {
  AppInitCubit() : super(AppInitInitial());

  setAsInitiating() {
    emit(AppInitiating());
  }

  setAsInitiated() {
    emit(AppInitiated());
  }

  setAsFailInitiated(Exception ex) {
    emit(AppFailedInitiated(ex));
  }
}
