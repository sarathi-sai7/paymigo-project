import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';

class ClaimSubmitScreen extends StatefulWidget {
  const ClaimSubmitScreen({super.key});

  @override
  State<ClaimSubmitScreen> createState() => _ClaimSubmitScreenState();
}

class _ClaimSubmitScreenState extends State<ClaimSubmitScreen> {
  final descController = TextEditingController();
  final amountController = TextEditingController();

  bool loading = false;

  Future<void> submit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final desc = descController.text.trim();
    final amount = double.tryParse(amountController.text.trim()) ?? 0;

    if (desc.isEmpty || amount <= 0) return;

    try {
      setState(() => loading = true);

      await ApiService.submitClaim(
        firebaseUid: user.uid,
        amount: amount,
      );

      setState(() => loading = false);

      Navigator.pop(context);
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Submit Claim"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            children: [

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade100, Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "AI processes your claim instantly ⚡",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  prefixText: "₹ ",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit Claim"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}