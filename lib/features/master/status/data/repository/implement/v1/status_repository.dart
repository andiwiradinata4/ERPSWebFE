import 'dart:convert';
import 'package:erps/core/error/error_response_exception.dart';
import 'package:erps/core/models/pagination.dart';
import 'package:erps/core/network/http/abstract/abs_http_client.dart';
import 'package:erps/core/network/http/http_status.dart';
import 'package:erps/features/master/status/data/models/status.dart';
import 'package:erps/features/master/status/data/repository/abstract/v1/abs_status_repository.dart';

class StatusRepository implements AbsStatusRepository {
  final AbsHttpClient client;

  StatusRepository({required this.client});

  @override
  Future<Pagination> listData(Map<String, String>? queries) async {
    Pagination<Status> pagination = Pagination();
    List<Status> allData = [];
    String url = 'api/v1/status';

    try {
      final response = await client.get(url, queries: queries);
      if (HTTPStatus.isSuccess(response.statusCode)) {
        final json = jsonDecode(response.body);
        allData = (json['Data'] as List<dynamic>)
            .map((e) => Status.fromJson(e))
            .toList();
        pagination = pagination.fromJson(
            json, allData, allData.map((e) => e.toJson()).toList());
      } else if (response.statusCode == HTTPStatus.HTTP_404_NOT_FOUND) {
        Map<String, dynamic> json = {'count': 0, 'next': '', 'previous': ''};
        pagination = pagination.fromJson(json, allData, json['Data']);
      } else {
        throw (ErrorResponseException.fromHttpResponse(response));
      }
    } catch (e) {
      rethrow;
    }
    return pagination;
  }

  @override
  Future createData(Status data) {
    // TODO: implement createData
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteData(Status data) {
    // TODO: implement deleteData
    throw UnimplementedError();
  }

  @override
  Future<bool> updateData(Status data) {
    // TODO: implement updateData
    throw UnimplementedError();
  }

  @override
  Future<Status> getDetail(Status data) {
    // TODO: implement getDetail
    throw UnimplementedError();
  }
}
