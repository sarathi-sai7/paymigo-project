import 'package:flutter/material.dart';

class AIModelsScreen extends StatelessWidget {
  const AIModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final models = [
      {
        "title": "Premium Engine",
        "algo": "XGBoost",
        "desc": "Calculates premiums using worker data & rainfall history.",
        "icon": Icons.trending_up,
        "color": Colors.orange,
      },
      {
        "title": "Fraud Detector",
        "algo": "Isolation Forest",
        "desc": "Detects anomalies in GPS & payout patterns.",
        "icon": Icons.security,
        "color": Colors.red,
      },
      {
        "title": "Risk Forecaster",
        "algo": "LSTM",
        "desc": "Predicts disruption risk using weather data.",
        "icon": Icons.cloud,
        "color": Colors.blue,
      },
      {
        "title": "Zone Clusterer",
        "algo": "K-Means",
        "desc": "Groups delivery zones based on risk.",
        "icon": Icons.public,
        "color": Colors.green,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔥 PREMIUM APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: const [
            Icon(Icons.shield, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              "Paymigo AI",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HERO TEXT
            const Text(
              "AI Engine",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Smart models powering risk, fraud & payouts",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// 🔥 MODEL CARDS
            ...models.map((m) => buildModelCard(m)).toList(),

            const SizedBox(height: 30),

            /// 🔥 PIPELINE TITLE
            const Text(
              "Real-time Pipeline",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            buildPipeline(),
          ],
        ),
      ),
    );
  }

  /// 🔥 PREMIUM MODEL CARD
  Widget buildModelCard(Map m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [

          /// ICON
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (m["color"] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(m["icon"] as IconData,
                color: m["color"] as Color),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Text(
                      m["title"] as String,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// TAG
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        m["algo"] as String,
                        style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 10),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  m["desc"] as String,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                Row(
                  children: const [
                    Icon(Icons.speed, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("120ms",
                        style: TextStyle(color: Colors.grey, fontSize: 10)),
                    SizedBox(width: 10),
                    Icon(Icons.check_circle,
                        size: 14, color: Colors.green),
                    SizedBox(width: 4),
                    Text("94%",
                        style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 🔥 PIPELINE
  Widget buildPipeline() {
    final steps = [
      {"title": "Ingestion", "desc": "IMD API + IoT Data", "icon": Icons.storage},
      {"title": "Processing", "desc": "ML Models", "icon": Icons.memory},
      {"title": "Execution", "desc": "Instant Payouts", "icon": Icons.flash_on},
    ];

    return Column(
      children: steps.map((s) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(s["icon"] as IconData, color: Colors.orange),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s["title"] as String,
                      style: const TextStyle(color: Colors.black)),
                  Text(s["desc"] as String,
                      style: const TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}