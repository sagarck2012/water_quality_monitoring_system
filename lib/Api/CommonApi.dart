import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchData(String token) async {
    print("Test 2");
    try {
      final response = await http.get(
        Uri.parse('http://182.163.112.102:8007/api/devices/list-device/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> dataList = responseData['data'];

        List<Map<String, dynamic>> mappedDataList = dataList
            .map<Map<String, dynamic>>(
                (item) => item as Map<String, dynamic>)
            .toList();

        return mappedDataList;
      }



      else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}