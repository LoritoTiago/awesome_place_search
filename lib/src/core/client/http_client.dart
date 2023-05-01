import 'package:http/http.dart';

class HttpClient{
  final http = Client();

  Future<Response> get({required String authority, required String path, required Map<String, dynamic> param}){
    return http.get(Uri.https(authority, path, param)).timeout(const Duration(seconds: 20));
  }
}