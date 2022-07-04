import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exception/generic_exception.dart';
import '../helpers/shared_preferences_helper.dart';


Future<Map<String, String>> _headersWithToken(
    Map<String, String> headers) async {
  var savedToken =
      await SharedPreferencesHelper.getValue(SharedPreferencesHelper.token);
  if (savedToken.isNotEmpty) {
    headers['token'] = savedToken;
  }
  return headers;
}

Future post(String url, Map<String, String> headers, dynamic body) async => http
        .post(Uri.parse(url),
            body: jsonEncode(body),
            headers: (await _headersWithToken({
              'Content-Type': 'application/json; charset=UTF-8',
            })))
        .then((response) {
      return (response.statusCode >= 200 && response.statusCode < 300)
          ? (response.body.isNotEmpty ? jsonDecode(response.body) : '')
          : throw GenericException(response);
    });

Future put(String url, Map<String, String> headers, dynamic body) async => http
        .put(Uri.parse(url),
            body: jsonEncode(body),
            headers: (await _headersWithToken({
              'Content-Type': 'application/json; charset=UTF-8',
            })))
        .then((response) {
      return (response.statusCode >= 200 && response.statusCode < 300)
          ? (response.body.isNotEmpty ? jsonDecode(response.body) : '')
          : throw GenericException(response);
    });

Future get(String url, Map<String, String> headers) async =>
    http.get(Uri.parse(url), headers: await _headersWithToken(headers)).then((response) {
      return (response.statusCode >= 200 && response.statusCode < 300)
          ? (response.body.isNotEmpty ? jsonDecode(response.body) : '')
          : throw GenericException(response);
    });

Future<T> postFormData<T>(String url, dynamic body) async => http
        .post(Uri.parse(url),
            body: body,
            headers: (await _headersWithToken({
              'Content-Type': 'application/x-www-form-urlencoded',
            })))
        .then((response) {
      return (response.statusCode >= 200 && response.statusCode < 300)
          ? (response.body.isNotEmpty ? jsonDecode(response.body) : '')
          : throw GenericException(response);
    });

Future delete(String url, Map<String, String> headers) async => http
        .delete(Uri.parse(url), headers: await _headersWithToken(headers))
        .then((response) {
      return (response.statusCode >= 200 && response.statusCode < 300)
          ? (response.body.isNotEmpty ? jsonDecode(response.body) : '')
          : throw GenericException(response);
    });
