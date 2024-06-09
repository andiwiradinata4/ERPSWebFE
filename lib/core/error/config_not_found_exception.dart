class ConfigNotFoundException implements Exception {
  final String _key;

  ConfigNotFoundException(this._key);

  @override
  String toString() {
    return "no configuration with key '$_key' was found";
  }
}

class ConfigFoundException implements Exception {
  final String _key;

  ConfigFoundException(this._key);

  @override
  String toString() {
    return "configuration with key '$_key' was found";
  }
}
