import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/network/network_info.dart';
import 'package:movie_app/core/network/server_info.dart';

class ServerApiClient {
  final NetworkInfoRepository networkInfoRepository;

  ServerApiClient({required this.networkInfoRepository});

  Future<http.Response> _request(
    String method, {
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final url = Uri(
      scheme: serverSchemaSecure,
      host: baseUrl,
      path: path,
      queryParameters: queryParameters,
    );

    final allHeaders = headers ?? {};
    if (!allHeaders.containsKey('Content-Type')) {
      allHeaders['Content-Type'] = 'application/json';
      allHeaders['accept'] = 'application/json';
    }

    try {
      http.Response response;
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
      final check = await networkInfoRepository.hasConnection;
      if (!check) {
        // Handle network error
      }
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
    } else {
      // Handle server errors
      return response as T;
    }
  }

  String _formatResponseLog(http.Response response, {Object? requestBody}) {
    final time = DateTime.now().toUtc().toIso8601String();
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String formattedRequestBody =
        requestBody != null ? encoder.convert(requestBody) : '';
    String formattedBodyJson;
    try {
      final json = jsonDecode(response.body);
      formattedBodyJson = encoder.convert(json);
    } catch (e) {
      formattedBodyJson = response.body;
    }
    return '''
  $time
  Request: ${response.request}${formattedRequestBody.isNotEmpty ? '\n  Request body: $formattedRequestBody' : ''}
  Response code: ${response.statusCode}
  Body: $formattedBodyJson
  ''';
  }
}
