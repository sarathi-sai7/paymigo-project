import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  /// 🔍 GET USER DATA
  Future<Map<String, dynamic>?> getWorker(String uid) async {
    final doc = await db.collection('workers').doc(uid).get();
    return doc.data();
  }

  /// 🔴 REAL-TIME STREAM
  Stream<DocumentSnapshot> workerStream(String uid) {
    return db.collection('workers').doc(uid).snapshots();
  }

  /// ✏️ UPDATE USER DATA (🔥 FIX)
  Future<void> updateWorker(String uid, Map<String, dynamic> data) async {
    await db.collection('workers').doc(uid).set(
      data,
      SetOptions(merge: true),
    );
  }
}