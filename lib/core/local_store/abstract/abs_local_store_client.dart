abstract class LocalStoreClient {
  Future<void> store({required String key, required String value});

  Future<String?> read({required String key});

  Future<void> delete({required String key});
}
