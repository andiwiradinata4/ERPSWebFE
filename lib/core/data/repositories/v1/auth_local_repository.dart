import 'dart:convert';

import 'package:erps/core/domain/repositories/v1/abs_auth_local_repository.dart';
import 'package:erps/core/local_store/implement/secure_local_store_client.dart';
import 'package:erps/core/models/token.dart';

class AuthLocalRepository implements AbsAuthLocalRepository {
  final String storeKey;
  final SecureLocalStoreClient client;

  AuthLocalRepository({required this.client, required this.storeKey});

  @override
  Future<Token?> get() async {
    var json = await client.storage.read(key: storeKey);
    if (json == null) return null;
    var jsonMap = jsonDecode(json);
    return Token.fromJson(jsonMap);
  }

  @override
  Future<void> store(Token accessToken) async {
    var json = jsonEncode(accessToken.toJson());
    await client.storage.write(key: storeKey, value: json);
  }

  @override
  Future<void> delete() async {
    await client.storage.delete(key: storeKey);
  }
}