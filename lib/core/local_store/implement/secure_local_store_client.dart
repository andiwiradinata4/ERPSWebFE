
import 'package:erps/core/local_store/abstract/abs_local_store_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureLocalStoreClient implements LocalStoreClient {
  final FlutterSecureStorage storage;

  SecureLocalStoreClient(
      {IOSOptions iosOptions = IOSOptions.defaultOptions,
        AndroidOptions androidOptions = AndroidOptions.defaultOptions,
        LinuxOptions linuxOptions = LinuxOptions.defaultOptions,
        MacOsOptions macOsOptions = MacOsOptions.defaultOptions,
        WebOptions webOptions = WebOptions.defaultOptions})
      : storage = FlutterSecureStorage(
      iOptions: iosOptions,
      aOptions: androidOptions,
      lOptions: linuxOptions,
      mOptions: macOsOptions,
      webOptions: webOptions);

  @override
  Future<void> store({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return await storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await storage.delete(key: key);
  }
}
