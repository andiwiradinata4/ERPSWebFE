import 'dart:io';
import 'package:erps/core/models/response.dart';

abstract class AbsHttpClient {
  void addHeaders(Map<String, String> headers);

  void removeHeader(String key);

  Future<Response> get(String url,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false});

  Future<Response> post(String url, Map<String, dynamic> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false});

  Future<Response> postAll(String url, List<Map<String, dynamic>> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false});

  Future<Response> put(String url, Map<String, dynamic> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false});

  Future<Response> patch(String url, Map<String, dynamic> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false});

  Future<Response> delete(String url, Map<String, dynamic> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false});

  Future<Response> upload(String url, File file,
      {Map<String, String>? headers,
      String fieldFileName = 'file',
      Map<String, dynamic>? body,
      Map<String, String>? queries,
      String method = 'POST',
      bool fullUrl = false});

  Future<Response> uploads(String url, List<File> file,
      {Map<String, String>? headers,
      String fieldFileName = 'file',
      Map<String, dynamic>? body,
      Map<String, String>? queries,
      String method = 'POST',
      bool fullUrl = false});
}