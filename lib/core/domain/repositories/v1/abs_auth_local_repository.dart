import 'package:erps/core/models/token.dart';

abstract class AbsAuthLocalRepository {
  Future<void> store(Token accessToken);

  Future<Token?> get();

  Future<void> delete();
}
