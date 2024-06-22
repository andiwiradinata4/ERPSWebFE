// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

class DateUtil {
  static const String QUERY_DATE_FORMAT = "dd-MM-yyyy";
  static const String QUERY_DATETIME_FORMAT = "dd-MM-yyyy HH:mm:ss";
  static const String SERVER_DATE_FORMAT = "yyyy-MM-dd";
  static const String SERVER_DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
  static const String LONG_TIME_FORMAT = "HH:mm:ss";
  static const String SHORT_TIME_FORMAT = "HH:mm";
  static const String SHORT_DATE_FORMAT = "dd MMM yyyy";
  static const String LONG_DATE_FORMAT = "dd MMMM yyyy";
  static const String SHORT_DATE_TIME_FORMAT = "E, dd MMM yyyy HH:mm";

  static DateUtil? instance() {
    return DateUtil();
  }

  String format(String format, DateTime? data, {String locale = "EN"}) {
    if (data == null) return "";
    final dataReturn = data.toString();
    return data.toString();
    // return DateFormat(format, locale).format(data);
  }

  DateTime parse(String data) {
    return DateTime.parse(data);
  }

  int? toMillis(DateTime? data) {
    if (data == null) return null;
    return data.millisecondsSinceEpoch;
  }

  DateTime? fromMillis(int? millis) {
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  int getWeekDay() {
    var moonLanding = DateTime.parse(DateTime.now().toString());
    return moonLanding.weekday;
  }

  int getNowMillisSecond() =>
      DateTime.now().toUtc().microsecondsSinceEpoch ~/ 1000000;
}
