import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  double balance = 0;
  List transactions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadWallet();
  }

  Future<void> loadWallet() async {
    try {
      final data = await ApiService.getWallet(uid);

      setState(() {
        balance = (data["balance"] ?? 0).toDouble();
        transactions = data["transactions"] ?? [];
        loading = false;
      });
    } catch (e) {
      print("Wallet error: $e");
      setState(() => loading = false);
    }
  }

  Future<void> addMoney() async {
    try {
      await ApiService.addMoney(
        firebaseUid: uid,
        amount: 500,
      );

      await loadWallet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("₹500 Added")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Wallet"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: loadWallet,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// 🔥 BALANCE CARD
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF7A00), Color(0xFFFFA726)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Wallet Balance",
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text(
                    "₹ ${balance.toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: addMoney,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.orange,
                          ),
                          child: const Text("Add ₹500"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 TRANSACTIONS
            const Text(
              "Transaction History",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),

            const SizedBox(height: 10),

            transactions.isEmpty
                ? const Center(child: Text("No Transactions Yet"))
                : Column(
                    children: transactions.map((tx) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_wallet,
                                color: Colors.green),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx["provider"] ?? "Payout",
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold),
                                  ),
                                  Text(
                                    tx["status"] ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              "₹${tx["amount"]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 20),

            /// 🔥 INSIGHTS (STATIC OK)
            buildProgress("This Month", 0.6, "₹3,500"),
            const SizedBox(height: 10),
            buildProgress("Lifetime", 0.8, "₹12,400"),
          ],
        ),
      ),
    );
  }

  Widget buildProgress(String title, double value, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.grey)),
            Text(amount,
                style: const TextStyle(color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          color: Colors.orange,
          backgroundColor: Colors.grey[300],
        )
      ],
    );
  }
}