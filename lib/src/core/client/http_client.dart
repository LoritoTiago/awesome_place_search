import 'package:http/http.dart';

class HttpClient {
  final http = Client();

  Future<Response> get(
      {required String authority,
      required String path,
      required Map<String, dynamic> param,
      Map<String, String>? headers}) {
    return http
        .get(Uri.https(authority, path, param), headers: headers)
        .timeout(const Duration(seconds: 20));
  }
}
