import 'package:erps/core/local_store/abstract/abs_local_store_client.dart';
import 'package:hive/hive.dart';

class HiveLocalStoreClient extends LocalStoreClient {
  String box;

  HiveLocalStoreClient({required this.box});

  Future<Box> getBox() async {
    if (!Hive.isBoxOpen(box)) {
      await Hive.openBox(box);
    }
    return Hive.box(box);
  }

  @override
  Future<void> store({required String key, required String value}) async {
    var box = await getBox();
    await box.put(key, value);
  }

  @override
  Future<void> delete({required String key}) async {
    var box = await getBox();
    await box.delete(key);
  }

  @override
  Future<String> read({required String key}) async {
    var box = await getBox();
    return await box.get(key);
  }
}
