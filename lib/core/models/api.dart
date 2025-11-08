import 'dart:convert';
import 'response_model.dart';
import 'package:http/http.dart' as http;

class API {
  static const String baseUrl =
      "https://api.dictionaryapi.dev/api/v2/entries/en/";

  static Future<ResponseModel> fetchMeaning(String word,
      {String? language}) async {
    final uri = Uri.parse(language != null
        ? "$baseUrl$word?language=$language"
        : "$baseUrl$word");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty && data[0] is Map<String, dynamic>) {
        return ResponseModel.fromJson(
            Map<String, dynamic>.from(data[0] as Map));
      }
      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to load meaning: ${response.statusCode}');
    }
  }
}
