import 'dart:convert';
import 'dart:io';
import 'package:erps/core/models/response.dart';
import 'package:erps/core/network/http/abstract/abs_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class HttpClient implements AbsHttpClient {
  final http.Client client;
  final String host, apiKey;
  final Map<String, String> headers = {};
  final int timeout;

  HttpClient(
      {required this.client,
      required this.host,
      required this.apiKey,
      this.timeout = 60}) {
    headers["api-key"] = apiKey;
  }

  @override
  void addHeaders(Map<String, String> headers) => this.headers.addAll(headers);

  @override
  void removeHeader(String key) => headers.remove(key);

  @override
  Future<Response> get(String url,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false}) async {
    final completeUrl =
        (fullUrl) ? Uri.parse(url) : _buildUrl(url, queries: queries);
    final http.Response response = await client
        .get(completeUrl, headers: _buildHeaders(headers))
        .timeout(Duration(seconds: timeout));
    return Response(response.statusCode, response.body);
  }

  @override
  Future<Response> post(String url, Map<String, dynamic> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false}) async {
    final completeUrl =
        (fullUrl) ? Uri.parse(url) : _buildUrl(url, queries: queries);
    final String stringBody = jsonEncode(body);
    final http.Response response = await client
        .post(completeUrl, headers: _buildHeaders(headers), body: stringBody)
        .timeout(Duration(seconds: timeout));
    return Response(response.statusCode, response.body);
  }

  @override
  Future<Response> postAll(String url, List<Map<String, dynamic>> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false}) async {
    final completeUrl =
        (fullUrl) ? Uri.parse(url) : _buildUrl(url, queries: queries);
    headers ??= {};
    headers["Content-Type"] = "application/json";
    final String stringBody = jsonEncode(body);
    final http.Response response = await client
        .post(completeUrl, headers: _buildHeaders(headers), body: stringBody)
        .timeout(Duration(seconds: timeout));
    return Response(response.statusCode, response.body);
  }

  @override
  Future<Response> put(String url, Map<String, dynamic> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false}) async {
    final completeUrl =
        (fullUrl) ? Uri.parse(url) : _buildUrl(url, queries: queries);
    headers ??= {};
    headers["Content-Type"] = "application/json";
    final String stringBody = jsonEncode(body);
    final http.Response response = await client
        .put(completeUrl, headers: _buildHeaders(headers), body: stringBody)
        .timeout(Duration(seconds: timeout));
    return Response(response.statusCode, response.body);
  }

  @override
  Future<Response> patch(String url, Map<String, dynamic> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false}) async {
    final completeUrl =
        (fullUrl) ? Uri.parse(url) : _buildUrl(url, queries: queries);
    headers ??= {};
    headers["Content-Type"] = "application/json";
    final String stringBody = jsonEncode(body);
    final http.Response response = await client
        .patch(completeUrl, headers: _buildHeaders(headers), body: stringBody)
        .timeout(Duration(seconds: timeout));
    return Response(response.statusCode, response.body);
  }

  @override
  Future<Response> delete(String url, Map<String, dynamic> body,
      {Map<String, String>? headers,
      Map<String, String>? queries,
      bool fullUrl = false}) async {
    final completeUrl =
        (fullUrl) ? Uri.parse(url) : _buildUrl(url, queries: queries);
    final http.Response response = await client
        .delete(completeUrl, headers: _buildHeaders(headers))
        .timeout(Duration(seconds: timeout));
    return Response(response.statusCode, response.body);
  }

  @override
  Future<Response> upload(String url, File file,
      {Map<String, String>? headers,
      String fieldFileName = 'file',
      Map<String, dynamic>? body,
      Map<String, String>? queries,
      String method = 'POST',
      bool fullUrl = false}) async {
    http.MultipartRequest request =
        http.MultipartRequest(method, _buildUrl(url, queries: queries));
    request.headers.addAll(_buildHeaders(headers));
    http.MultipartFile multipart = await http.MultipartFile.fromPath(
        fieldFileName, file.path,
        contentType: MediaType.parse(mime(file.path) ?? ""));
    request.files.add(multipart);

    if (body != null) {
      body.entries.map((e) => request.fields[e.key] = e.value);
    }

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return Response(response.statusCode, response.body);
  }

  @override
  Future<Response> uploads(String url, List<File> file,
      {Map<String, String>? headers,
      String fieldFileName = 'file',
      Map<String, dynamic>? body,
      Map<String, String>? queries,
      String method = 'POST',
      bool fullUrl = false}) async {
    http.MultipartRequest request =
        http.MultipartRequest(method, _buildUrl(url, queries: queries));
    request.headers.addAll(_buildHeaders(headers));

    for (File e in file) {
      http.MultipartFile multipart = await http.MultipartFile.fromPath(
          fieldFileName, e.path,
          contentType: MediaType.parse(mime(e.path) ?? ""));
      request.files.add(multipart);
    }

    if (body != null) {
      body.entries.map((e) => request.fields[e.key] = e.value);
    }

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return Response(response.statusCode, response.body);
  }

  /// This method is to build url and combine with queries
  Uri _buildUrl(String baseUrl, {Map<String, String>? queries}) {
    String url = '';
    url = host + baseUrl;

    int i = 0;
    /**
     * Check whether the current url has contain query string before.
     */
    RegExp regExp =
        RegExp(r'/\?.+=.*/g', caseSensitive: false, multiLine: false);
    if (regExp.hasMatch(url)) {
      i = 1;
    }

    /**
     * Put the query string into the url
     */
    queries?.forEach((key, value) {
      if (i == 0) {
        url += "?";
      } else {
        url += "&";
      }
      url += "$key=$value";
      i++;
    });

    return Uri.parse(url);
  }

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    headers ??= {};
    headers["Content-Type"] = "application/json";
    headers.addAll(this.headers);
    return headers;
  }
}
