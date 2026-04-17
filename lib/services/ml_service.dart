import 'dart:convert';
import 'package:http/http.dart' as http;

class MLService {
  static const baseUrl = "http://10.0.2.2:8000";

  static Future<Map<String, dynamic>> checkFraud(Map data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/fraud/check"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {"is_fraud": false, "confidence": 0.99};
    }
  }
}