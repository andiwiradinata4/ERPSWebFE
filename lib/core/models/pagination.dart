// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Pagination<T> extends Equatable {
  late int count;
  late List<T> results;
  late List<dynamic>? jsonResults;

  Pagination({this.count = 0, this.results = const [], this.jsonResults});

  @override
  List<Object> get props => [count];

  fromJson(
      Map<String, dynamic>? json, List<T> results, List<dynamic>? jsonResults) {
    if (json == null) {
      return;
    }

    Pagination pagination = Pagination(
        count: json["count"] ?? 0, results: results, jsonResults: jsonResults);
    return pagination;
  }
}

class PerPageValue extends Equatable {
  final int pageValue;
  final String label;

  const PerPageValue(this.pageValue, this.label);

  @override
  List<Object?> get props => [pageValue, label];
}

List<PerPageValue> dataPerPageValue() => [
      initPerPageValue(),
      const PerPageValue(30, '30'),
      const PerPageValue(100, '100'),
      const PerPageValue(9999999999, 'All'),
    ];

PerPageValue initPerPageValue() => const PerPageValue(10, '10');
