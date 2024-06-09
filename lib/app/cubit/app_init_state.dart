part of 'app_init_cubit.dart';

@immutable
abstract class AppInitState {}

class AppInitInitial extends AppInitState {}

class AppInitiating extends AppInitState {}

class AppInitiated extends AppInitState {}

class AppFailedInitiated extends AppInitState {
  final Exception ex;

  AppFailedInitiated(this.ex);
}
