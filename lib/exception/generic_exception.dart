import 'package:http/http.dart';

class GenericException implements Exception {
  Response httpResponse;

  GenericException(this.httpResponse);
}
