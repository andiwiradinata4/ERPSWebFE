// ignore_for_file: constant_identifier_names

class HTTPStatus {
  static const HTTP_100_CONTINUE = 100;
  static const HTTP_101_SWITCHING_PROTOCOLS = 101;
  static const HTTP_200_OK = 200;
  static const HTTP_201_CREATED = 201;
  static const HTTP_202_ACCEPTED = 202;
  static const HTTP_203_NON_AUTHORITATIVE_INFORMATION = 203;
  static const HTTP_204_NO_CONTENT = 204;
  static const HTTP_205_RESET_CONTENT = 205;
  static const HTTP_206_PARTIAL_CONTENT = 206;
  static const HTTP_207_MULTI_STATUS = 207;
  static const HTTP_208_ALREADY_REPORTED = 208;
  static const HTTP_226_IM_USED = 226;
  static const HTTP_300_MULTIPLE_CHOICES = 300;
  static const HTTP_301_MOVED_PERMANENTLY = 301;
  static const HTTP_302_FOUND = 302;
  static const HTTP_303_SEE_OTHER = 303;
  static const HTTP_304_NOT_MODIFIED = 304;
  static const HTTP_305_USE_PROXY = 305;
  static const HTTP_306_RESERVED = 306;
  static const HTTP_307_TEMPORARY_REDIRECT = 307;
  static const HTTP_308_PERMANENT_REDIRECT = 308;
  static const HTTP_400_BAD_REQUEST = 400;
  static const HTTP_401_UNAUTHORIZED = 401;
  static const HTTP_402_PAYMENT_REQUIRED = 402;
  static const HTTP_403_FORBIDDEN = 403;
  static const HTTP_404_NOT_FOUND = 404;
  static const HTTP_405_METHOD_NOT_ALLOWED = 405;
  static const HTTP_406_NOT_ACCEPTABLE = 406;
  static const HTTP_407_PROXY_AUTHENTICATION_REQUIRED = 407;
  static const HTTP_408_REQUEST_TIMEOUT = 408;
  static const HTTP_409_CONFLICT = 409;
  static const HTTP_410_GONE = 410;
  static const HTTP_411_LENGTH_REQUIRED = 411;
  static const HTTP_412_PRECONDITION_FAILED = 412;
  static const HTTP_413_REQUEST_ENTITY_TOO_LARGE = 413;
  static const HTTP_414_REQUEST_URI_TOO_LONG = 414;
  static const HTTP_415_UNSUPPORTED_MEDIA_TYPE = 415;
  static const HTTP_416_REQUESTED_RANGE_NOT_SATISFIABLE = 416;
  static const HTTP_417_EXPECTATION_FAILED = 417;
  static const HTTP_418_IM_A_TEAPOT = 418;
  static const HTTP_422_UNPROCESSABLE_ENTITY = 422;
  static const HTTP_423_LOCKED = 423;
  static const HTTP_424_FAILED_DEPENDENCY = 424;
  static const HTTP_426_UPGRADE_REQUIRED = 426;
  static const HTTP_428_PRECONDITION_REQUIRED = 428;
  static const HTTP_429_TOO_MANY_REQUESTS = 429;
  static const HTTP_431_REQUEST_HEADER_FIELDS_TOO_LARGE = 431;
  static const HTTP_451_UNAVAILABLE_FOR_LEGAL_REASONS = 451;
  static const HTTP_500_INTERNAL_SERVER_ERROR = 500;
  static const HTTP_501_NOT_IMPLEMENTED = 501;
  static const HTTP_502_BAD_GATEWAY = 502;
  static const HTTP_503_SERVICE_UNAVAILABLE = 503;
  static const HTTP_504_GATEWAY_TIMEOUT = 504;
  static const HTTP_505_HTTP_VERSION_NOT_SUPPORTED = 505;
  static const HTTP_506_VARIANT_ALSO_NEGOTIATES = 506;
  static const HTTP_507_INSUFFICIENT_STORAGE = 507;
  static const HTTP_508_LOOP_DETECTED = 508;
  static const HTTP_509_BANDWIDTH_LIMIT_EXCEEDED = 509;
  static const HTTP_510_NOT_EXTENDED = 510;
  static const HTTP_511_NETWORK_AUTHENTICATION_REQUIRED = 511;

  static bool isInformational(int code) {
    if (code >= 100 && code <= 199) {
      return true;
    }
    return false;
  }

  static bool isSuccess(int code) {
    if (code >= 200 && code <= 299) {
      return true;
    }
    return false;
  }

  static bool isRedirect(int code) {
    if (code >= 300 && code <= 399) {
      return true;
    }
    return false;
  }

  static bool isClientError(int code) {
    if (code >= 400 && code <= 499) {
      return true;
    }
    return false;
  }

  static bool isServerError(int code) {
    if (code >= 500 && code <= 599) {
      return true;
    }
    return false;
  }
}
