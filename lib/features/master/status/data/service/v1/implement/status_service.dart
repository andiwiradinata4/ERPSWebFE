import 'package:erps/core/models/pagination.dart';
import 'package:erps/features/master/status/data/models/status.dart';
import 'package:erps/features/master/status/data/repository/abstract/v1/abs_status_repository.dart';
import 'package:erps/features/master/status/data/service/v1/abstract/abs_status_service.dart';

class StatusService extends AbsStatusService {
  final AbsStatusRepository statusRepository;

  StatusService({required this.statusRepository});

  @override
  Future<Pagination> listData(Map<String, String>? queries) async {
    return await statusRepository.listData(queries);
  }

  @override
  Future createData(Status data) async {
    return await statusRepository.createData(data);
  }

  @override
  Future<bool> updateData(Status data) async {
    return await statusRepository.updateData(data);
  }

  @override
  Future<bool> deleteData(Status data) async {
    return await statusRepository.deleteData(data);
  }

  @override
  Future<Status> getDetail(Status data) async {
    return await statusRepository.getDetail(data);
  }
}