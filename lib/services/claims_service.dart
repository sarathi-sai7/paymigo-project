import 'package:cloud_firestore/cloud_firestore.dart';
import 'ml_service.dart';

class ClaimsService {
  final db = FirebaseFirestore.instance;

  Future<void> submitClaim({
    required String uid,
    required String description,
    required double amount,
  }) async {

    /// 🔥 FRAUD CHECK
    final fraud = await MLService.checkFraud({
      "amount": amount,
      "desc": description,
    });

    final isFraud = fraud["is_fraud"] ?? false;

    await db.collection('claims').add({
      "workerId": uid,
      "description": description,
      "amount": amount,
      "status": isFraud ? "REJECTED" : "PENDING",
      "createdAt": Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getClaims(String uid) {
    return db
        .collection('claims')
        .where('workerId', isEqualTo: uid)
        .snapshots();
  }
}