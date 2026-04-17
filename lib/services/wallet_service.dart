import 'package:cloud_firestore/cloud_firestore.dart';
import 'payout_service.dart';
import 'loyalty_service.dart';

class WalletService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// 🔥 WALLET STREAM
  Stream<DocumentSnapshot<Map<String, dynamic>>> walletStream(String uid) {
    return db.collection('wallets').doc(uid).snapshots();
  }

  /// 🔥 GET WALLET
  Future<Map<String, dynamic>?> getWallet(String uid) async {
    final doc = await db.collection('wallets').doc(uid).get();
    return doc.data();
  }

  /// ➕ ADD MONEY (PRODUCTION SAFE)
  Future<void> addMoney({
    required String uid,
    required double amount,
    String type = "PAYOUT",
    String description = "",
  }) async {
    if (amount <= 0) {
      throw Exception("Invalid amount");
    }

    final walletRef = db.collection('wallets').doc(uid);

    try {
      await db.runTransaction((transaction) async {
        final snapshot = await transaction.get(walletRef);

        double currentBalance = 0;

        if (!snapshot.exists) {
          currentBalance = 0;

          transaction.set(walletRef, {
            "availableBalance": amount,
            "createdAt": FieldValue.serverTimestamp(),
          });
        } else {
          currentBalance =
              ((snapshot.data()?['availableBalance'] ?? 0) as num).toDouble();

          transaction.update(walletRef, {
            "availableBalance": currentBalance + amount,
          });
        }

        /// 🔥 TRANSACTION RECORD
        final txRef = walletRef.collection('transactions').doc();

        transaction.set(txRef, {
          "txId": txRef.id,
          "type": type,
          "amount": amount,
          "balanceAfter": currentBalance + amount,
          "description": description,
          "createdAt": FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw Exception("Add money failed: $e");
    }
  }

  /// 💸 WITHDRAW MONEY
  Future<void> withdraw({
    required String uid,
    required double amount,
  }) async {
    if (amount <= 0) {
      throw Exception("Invalid withdrawal amount");
    }

    final walletRef = db.collection('wallets').doc(uid);

    try {
      await db.runTransaction((transaction) async {
        final snapshot = await transaction.get(walletRef);

        if (!snapshot.exists) {
          throw Exception("Wallet not found");
        }

        double currentBalance =
            ((snapshot.data()?['availableBalance'] ?? 0) as num).toDouble();

        if (currentBalance < amount) {
          throw Exception("Insufficient balance");
        }

        transaction.update(walletRef, {
          "availableBalance": currentBalance - amount,
        });

        final txRef = walletRef.collection('transactions').doc();

        transaction.set(txRef, {
          "txId": txRef.id,
          "type": "WITHDRAW",
          "amount": amount,
          "balanceAfter": currentBalance - amount,
          "createdAt": FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw Exception("Withdraw failed: $e");
    }
  }

  /// 🚀 AUTO PAYOUT (SAFE + UNIQUE)
  Future<void> addAutoPayout({
    required String uid,
    required double hours,
    required String zone,
    required int weeks,
  }) async {
    if (hours <= 0) return;

    final zrm = PayoutService.getZoneRiskMultiplier(zone);
    final loyaltyBonus = LoyaltyService.calculateBonus(weeks);
    final loyalty = 1 + loyaltyBonus;

    final payout = PayoutService.calculatePayout(
      hours: hours,
      zrm: zrm,
      tier: 1.5,
      loyalty: loyalty,
    );

    final walletRef = db.collection('wallets').doc(uid);

    /// 🔥 STRONG DUPLICATE CHECK (using server timestamp window)
    final existing = await walletRef
        .collection('transactions')
        .where('type', isEqualTo: "AUTO_PAYOUT")
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      final lastTime = existing.docs.first.data()['createdAt'];

      if (lastTime != null &&
          lastTime.toDate().isAfter(
              DateTime.now().subtract(const Duration(minutes: 30)))) {
        print("⚠️ Duplicate payout prevented");
        return;
      }
    }

    await addMoney(
      uid: uid,
      amount: payout,
      type: "AUTO_PAYOUT",
      description: "Rainfall triggered payout",
    );
  }

  /// 📜 TRANSACTION STREAM
  Stream<QuerySnapshot<Map<String, dynamic>>> transactionStream(String uid) {
    return db
        .collection('wallets')
        .doc(uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}