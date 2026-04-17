import 'package:flutter/material.dart';

/// 🔥 MODEL CLASSES
class Stat {
  final String title;
  final String value;
  final Color color;

  Stat(this.title, this.value, this.color);
}

class Claim {
  final String id;
  final String worker;
  final String amount;
  final String status;

  Claim(this.id, this.worker, this.amount, this.status);
}

class InsurerScreen extends StatelessWidget {
  const InsurerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🔥 DATA
    final stats = [
      Stat("Policies", "12,450", Colors.orange),
      Stat("Premium", "₹5.2M", Colors.green),
      Stat("Loss Ratio", "32%", Colors.red),
      Stat("Avg Payout", "₹1240", Colors.blue),
    ];

    final claims = [
      Claim("CLM1", "Ravi", "₹1500", "Paid"),
      Claim("CLM2", "Suresh", "₹1500", "Paid"),
      Claim("CLM3", "Amit", "₹500", "Review"),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Insurer Dashboard"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔥 STATS SECTION
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stats.length,
                itemBuilder: (context, i) {
                  final stat = stats[i];

                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          stat.title,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          stat.value,
                          style: TextStyle(
                            color: stat.color,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// 📊 CHART PLACEHOLDER
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Chart Coming Soon 📊",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🌍 RISK ZONES
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  buildRisk("Chennai", 0.8, Colors.red),
                  buildRisk("Mumbai", 0.7, Colors.red),
                  buildRisk("Delhi", 0.5, Colors.orange),
                  buildRisk("Bangalore", 0.2, Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 📜 CLAIMS LIST
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: claims.map((claim) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      claim.worker,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      claim.id,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          claim.amount,
                          style: const TextStyle(color: Colors.orange),
                        ),
                        Text(
                          claim.status,
                          style: TextStyle(
                            color: claim.status == "Paid"
                                ? Colors.green
                                : Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 RISK BAR
  Widget buildRisk(String zone, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(zone, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: value,
          color: color,
          backgroundColor: Colors.grey,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}