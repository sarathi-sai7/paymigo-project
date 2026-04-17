import 'package:flutter/material.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        "title": "Data Ingestion",
        "desc": "Real-time weather data from IMD & IoT sensors",
        "icon": Icons.storage,
      },
      {
        "title": "AI Risk Assessment",
        "desc": "XGBoost models analyze disruption risk",
        "icon": Icons.memory,
      },
      {
        "title": "Parametric Trigger",
        "desc": "Auto trigger if rainfall > threshold",
        "icon": Icons.bolt,
      },
      {
        "title": "Instant Payout",
        "desc": "Money sent instantly to UPI",
        "icon": Icons.smartphone,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("How It Works"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// 🔥 HERO
            const Text(
              "The Science of\nAutomatic Protection",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Insurance that works automatically using AI triggers",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// 🚀 STEPS
            Column(
              children: steps.map((s) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [

                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          s["icon"] as IconData,
                          color: Colors.orange,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              s["title"] as String,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s["desc"] as String,
                              style: const TextStyle(
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// ⚖️ COMPARISON
            const Text(
              "Old vs Paymigo",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            buildCompareCard(
              title: "Traditional",
              items: [
                "Manual claims",
                "30+ days waiting",
                "Proof required",
                "High rejection",
              ],
              color: Colors.red,
            ),

            const SizedBox(height: 12),

            buildCompareCard(
              title: "Paymigo",
              items: [
                "Auto payout",
                "Instant UPI transfer",
                "No proof needed",
                "100% transparent",
              ],
              color: Colors.green,
            ),

            const SizedBox(height: 30),

            /// 📊 TECH STATS
            const Text(
              "Technology",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                techCard("Data Sources", "12+"),
                techCard("Precision", "500m"),
                techCard("AI Model", "XGBoost"),
                techCard("Security", "AES-256"),
              ],
            ),

            const SizedBox(height: 30),

            /// 🚀 CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/onboard");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(14),
                ),
                child: const Text("Get Started"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 COMPARE CARD
  Widget buildCompareCard(
      {required String title,
      required List<String> items,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...items.map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(i,
                    style:
                        const TextStyle(color: Colors.white)),
              ))
        ],
      ),
    );
  }

  /// 📊 TECH CARD
  Widget techCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}