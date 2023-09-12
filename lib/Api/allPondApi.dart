import 'package:http/http.dart' as http;
import 'dart:convert';

class PondApi {
  final String baseUrl;
  final String token;

  PondApi(this.baseUrl, this.token);

  Future<List<Map<String, dynamic>>> fetchPondData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/pond/list/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      throw Exception('Failed to fetch pond data');
    }
  }
}
