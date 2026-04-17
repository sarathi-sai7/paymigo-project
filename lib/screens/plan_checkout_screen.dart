import 'package:flutter/material.dart';

class PlanCheckoutScreen extends StatelessWidget {
  final String planId;

  const PlanCheckoutScreen({super.key, required this.planId});

  Map<String, dynamic>? getPlan() {
    final isMonsoon = DateTime.now().month >= 6 &&
        DateTime.now().month <= 9;

    final plans = {
      "basic": {
        "name": "Basic",
        "price": 49 + (isMonsoon ? 30 : 0),
        "payout": 800,
        "features": [
          "Rainfall > 25mm/hr",
          "AQI > 400",
          "4-hour payout"
        ]
      },
      "pro": {
        "name": "Pro",
        "price": 69 + (isMonsoon ? 30 : 0),
        "payout": 1500,
        "features": [
          "Rainfall > 15mm/hr",
          "90-sec payout",
          "Fuel Cashback"
        ]
      },
      "premium": {
        "name": "Premium",
        "price": 119 + (isMonsoon ? 40 : 0),
        "payout": 2500,
        "features": [
          "Rainfall > 10mm/hr",
          "Instant payout",
          "Max benefits"
        ]
      }
    };

    return plans[planId.toLowerCase()];
  }

  @override
  Widget build(BuildContext context) {
    final plan = getPlan();

    if (plan == null) {
      return Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Back to Plans"),
          ),
        ),
      );
    }
final price = (plan["price"] as num).toDouble();
    final gst = price * 0.18;
    final total = price + gst;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Checkout"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 📦 PLAN SUMMARY
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    plan["name"],
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹$price / week",
                    style: const TextStyle(
                        fontSize: 22, color: Colors.orange),
                  ),

                  const SizedBox(height: 15),

                  Text(
                  "Max Payout: ₹${(plan["payout"] as num).toDouble().toStringAsFixed(0)}",
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 15),

                  /// FEATURES
                  Column(
                    children: (plan["features"] as List<String>)
                        .map((f) => Row(
                              children: [
                                const Icon(Icons.check,
                                    color: Colors.green, size: 16),
                                const SizedBox(width: 6),
                                Text(f,
                                    style: const TextStyle(
                                        color: Colors.white70)),
                              ],
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ⚡ AUTO ACTIVATION
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Once confirmed, your protection starts instantly. No claims needed.",
                style: TextStyle(color: Colors.orange),
              ),
            ),

            const SizedBox(height: 20),

            /// 💳 BILLING
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  row("Weekly Premium", price),
                  row("GST (18%)", gst),
                  const Divider(color: Colors.white24),
                  row("Total", total, highlight: true),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔐 PAYMENT INFO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Secure test simulation (No real payment)",
                style: TextStyle(color: Colors.green),
              ),
            ),

            const SizedBox(height: 20),

            /// 🚀 CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/dashboard");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Confirm & Simulate Payment",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 ROW UI
  Widget row(String title, double value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70)),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: highlight ? Colors.orange : Colors.white,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}