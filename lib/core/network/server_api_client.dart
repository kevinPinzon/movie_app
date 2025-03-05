import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/network/server_info.dart';

class ServerApiClient {
  ServerApiClient();

  Future<http.Response> _request(
    String method, {
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final url = Uri.https(baseUrl, path, queryParameters);

    final allHeaders = headers ?? const {};
    allHeaders.putIfAbsent('Content-Type', () => 'application/json');
    allHeaders.putIfAbsent('accept', () => 'application/json');

    try {
      late http.Response response;
      switch (method) {
        case 'GET':
          response = await http.get(url, headers: allHeaders);
          break;
        case 'POST':
          response = await http.post(url,
              headers: allHeaders, body: jsonEncode(body), encoding: encoding);
          break;
        case 'PATCH':
          response = await http.patch(url,
              headers: allHeaders, body: jsonEncode(body), encoding: encoding);
          break;
        default:
          throw UnsupportedError('Method $method not supported');
      }

      if (kDebugMode) {
        log(_formatResponseLog(response, requestBody: body));
      }

      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> get(String path,
      {Map<String, String>? queryParameters, Map<String, String>? headers}) {
    return _request('GET',
        path: path, queryParameters: queryParameters, headers: headers);
  }

  Future<http.Response> post(String path,
      {Map<String, String>? queryParameters,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding}) {
    return _request('POST',
        path: path,
        queryParameters: queryParameters,
        headers: headers,
        body: body,
        encoding: encoding);
  }

  Future<http.Response> patch(String path,
      {Map<String, String>? queryParameters,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding}) {
    return _request('PATCH',
        path: path,
        queryParameters: queryParameters,
        headers: headers,
        body: body,
        encoding: encoding);
  }

  Future<T> _processResponse<T>(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return response as T;
    }
    return response as T;
  }

  String _formatResponseLog(http.Response response, {Object? requestBody}) {
    final time = DateTime.now().toUtc().toIso8601String();
    const encoder = JsonEncoder.withIndent('  ');
    final formattedRequestBody =
        requestBody != null ? encoder.convert(requestBody) : '';
    final formattedBodyJson = _tryDecodeJson(response.body, encoder);

    return '''
  $time
  Request: ${response.request}${formattedRequestBody.isNotEmpty ? '\n  Request body: $formattedRequestBody' : ''}
  Response code: ${response.statusCode}
  Body: $formattedBodyJson
  ''';
  }

  String _tryDecodeJson(String body, JsonEncoder encoder) {
    try {
      final json = jsonDecode(body);
      return encoder.convert(json);
    } catch (e) {
      return body;
    }
  }
}
