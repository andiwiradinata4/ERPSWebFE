import 'dart:convert';
import 'package:erps/core/error/config_not_found_exception.dart';

class Config {
  Map<String, dynamic> _defaultValue = <String, dynamic>{};
  final Map<String, dynamic> _config = <String, dynamic>{};

  static final Config _instance = Config();

  String get(key) {
    if (_instance._config.containsKey(key)) {
      return _config[key];
    } else if (_instance._defaultValue.containsKey(key)) {
      return _defaultValue[key];
    }
    throw ConfigNotFoundException(key);
  }

  static void addAll(Map<String, dynamic> config) {
    _instance._config.addAll(config);
  }

  static void add(String key, String value) {
    _instance._config[key] = value;
  }

  static void remove(String key) {
    _instance._config.remove(key);
  }

  static void setDefaultValue(Map<String, dynamic> defaultValue) {
    _instance._defaultValue = defaultValue;
  }

  static String? getString(String key) {
    return _instance.get(key);
  }

  static Map<String, dynamic>? getMap(String key) {
    String raw = _instance.get(key);
    return jsonDecode(raw);
  }

  static bool getBool(String key) {
    String raw = _instance.get(key);
    switch (raw.toUpperCase()) {
      case "true":
      case "TRUE":
      case "1":
        return true;
      default:
        return false;
    }
  }

  static double getDouble(String key) {
    String raw = _instance.get(key);
    return double.parse(raw);
  }

  static int getInt(String key) {
    String raw = _instance.get(key);
    return int.parse(raw);
  }

  static bool exists(String key) {
    return _instance._config.containsKey(key);
  }
}
