import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiManager {
  ApiManager._privateConstructor();

  static final ApiManager _instance = ApiManager._privateConstructor();

  static ApiManager get instance => _instance;

  static const String baseUrl =
      // 'fdr8m8nvve.execute-api.us-east-1.amazonaws.com';
      'localhost:3000';

  Future<dynamic> get(String endpoint, [Map<String, dynamic>? params]) async {
    // var url = Uri.https(baseUrl, endpoint, params);
    var url = Uri.http(baseUrl, endpoint, params);
    print(url);
    print(params);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // return json.decode(response.body);
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    // var url = Uri.https(baseUrl, endpoint);
    var url = Uri.http(baseUrl, endpoint);
    print(url);
    print(body);
    final response = await http.post(url, body: json.encode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    var url = Uri.https(baseUrl, endpoint);
    // var url = Uri.http(baseUrl, endpoint);
    print(url);
    print(body);
    final response = await http.put(url, body: json.encode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    var url = Uri.https(baseUrl, endpoint);
    // var url = Uri.http(baseUrl, endpoint);
    print(url);
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
