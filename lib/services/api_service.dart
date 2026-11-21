import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost/api-test/public';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/register'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getMembres() async {
    final response = await http.get(Uri.parse('$baseUrl/famille-membres'));
    final json = jsonDecode(response.body);
    if (json['success'] == true) {
      return json['data'] as List<dynamic>;
    }
    throw Exception(json['message'] ?? 'Erreur');
  }

  static Future<Map<String, dynamic>> createMembre(
      Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/famille-membres'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateMembre(
      int id, Map<String, String> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteMembre(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/famille-membres/$id'),
    );
    return jsonDecode(response.body);
  }
}