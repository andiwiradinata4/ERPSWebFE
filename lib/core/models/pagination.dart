// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Pagination<T> extends Equatable {
  late int count;
  late String next, previous;
  late List<T> results;
  late List<dynamic>? jsonResults;

  Pagination(
      {this.count = 0,
      this.next = "",
      this.previous = "",
      this.results = const [],
      this.jsonResults});

  @override
  List<Object> get props => [count, next, previous];

  fromJson(Map<String, dynamic>? json, List<T> results,
      List<dynamic>? jsonResults) {
    if (json == null) {
      return;
    }

    Pagination pagination = Pagination(
        count: json["count"] ?? 0,
        next: json["next"] ?? '',
        previous: json["previous"] ?? '',
        results: results,
        jsonResults: jsonResults);
    return pagination;
  }
}
