import 'package:erps/core/models/pagination.dart';

abstract class AbsBaseService<T> {
  Future<Pagination> listData(Map<String, String>? queries);

  Future<dynamic> createData(T data);

  Future<bool> updateData(T data);

  Future<bool> deleteData(T data);

  Future<T> getDetail(T data);
}
