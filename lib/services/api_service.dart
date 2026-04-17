import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// 🔥 BASE URL

  /// Android Emulator
  static const String baseUrl = "https://opium-mourner-udder.ngrok-free.dev";

  /// Real Device (change to your PC IP)
  /// static const String baseUrl = "http://192.168.1.5:3000";

  static const headers = {
    "Content-Type": "application/json",
  };

  /// 🔥 TIMEOUT
  static const Duration timeout = Duration(seconds: 10);

  /// 🔥 GENERIC GET
  static Future<dynamic> _get(String endpoint) async {
    try {
      final res = await http
          .get(Uri.parse("$baseUrl$endpoint"), headers: headers)
          .timeout(timeout);

      print("GET $endpoint → ${res.statusCode}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception(_parseError(res));
      }
    } catch (e) {
      throw Exception("GET error: $e");
    }
  }

  /// 🔥 GENERIC POST
  static Future<dynamic> _post(String endpoint, Map body) async {
    try {
      final res = await http
          .post(
            Uri.parse("$baseUrl$endpoint"),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);

      print("POST $endpoint → ${res.statusCode}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      } else {
        throw Exception(_parseError(res));
      }
    } catch (e) {
      throw Exception("POST error: $e");
    }
  }

  /// 🔥 GENERIC PUT
  static Future<void> _put(String endpoint, Map body) async {
    try {
      final res = await http
          .put(
            Uri.parse("$baseUrl$endpoint"),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);

      print("PUT $endpoint → ${res.statusCode}");

      if (res.statusCode != 200) {
        throw Exception(_parseError(res));
      }
    } catch (e) {
      throw Exception("PUT error: $e");
    }
  }

  /// 🔥 ERROR PARSER
  static String _parseError(http.Response res) {
    try {
      final data = jsonDecode(res.body);
      return data["message"] ?? "Unknown error";
    } catch (_) {
      return "Server error (${res.statusCode})";
    }
  }

  /// 🔥 HEALTH CHECK
  static Future<bool> checkServer() async {
    try {
      final res = await http
          .get(Uri.parse("$baseUrl/health"))
          .timeout(timeout);

      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// 🔥 CREATE WORKER
  static Future<void> createWorker({
    required String firebaseUid,
    required String name,
    required String phone,
  }) async {
    await _post("/api/workers", {
      "firebaseUid": firebaseUid,
      "name": name,
      "phone": phone,
    });
  }

  /// 🔥 GET PROFILE
  static Future<Map<String, dynamic>> getProfile(String uid) async {
    return await _get("/api/workers/$uid");
  }

  /// 🔥 UPDATE PROFILE
  static Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
    required String city,
  }) async {
    await _put("/api/workers/$uid", {
      "name": name,
      "phone": phone,
      "city": city,
    });
  }

  /// 🔥 SUBMIT CLAIM
  static Future<void> submitClaim({
    required String firebaseUid,
    required double amount,
  }) async {
    await _post("/api/payouts/claim", {
      "firebaseUid": firebaseUid,
      "amount": amount,
    });
  }

  /// 🔥 GET WALLET
  static Future<Map<String, dynamic>> getWallet(String uid) async {
    return await _get("/api/wallet/$uid");
  }

  /// 🔥 ADD MONEY
  static Future<void> addMoney({
    required String firebaseUid,
    required double amount,
  }) async {
    await _post("/api/wallet/add", {
      "firebaseUid": firebaseUid,
      "amount": amount,
    });
  }

  /// 🔥 GET TRIGGERS
  static Future<Map<String, dynamic>> getTriggers(String uid) async {
    final res = await _get("/api/triggers?firebaseUid=$uid");
    return res["data"];
  }

  /// 🔥 TRIGGER AUTO PAYOUT
  static Future<void> triggerPayout({
    required String uid,
    required double rainfall,
    required double threshold,
  }) async {
    try {
      final res = await _post("/api/ai/trigger-payout", {
        "firebaseUid": uid,
        "rainfall": rainfall,
        "threshold": threshold,
      });

      print("💸 Payout Triggered: $res");
    } catch (e) {
      print("❌ Payout Error: $e");
      throw Exception("Failed to trigger payout");
    }
  }

  /// 🔥 CALCULATE PREMIUM
  static Future<Map<String, dynamic>> calculatePremium({
    required int age,
    required String jobType,
    required int experienceYears,
    required String zone,
  }) async {
    final res = await _post("/api/premium/calculate", {
      "age": age,
      "jobType": jobType,
      "experienceYears": experienceYears,
      "zone": zone,
    });

    return res["data"];
  }
}