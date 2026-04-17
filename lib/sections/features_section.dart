import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        "title": "Parametric Trust",
        "desc": "Triggered by real-time data. No manual claims.",
        "icon": Icons.verified_user_outlined,
      },
      {
        "title": "Instant Payouts",
        "desc": "Money hits wallet in 90 seconds.",
        "icon": Icons.flash_on,
      },
      {
        "title": "AI Risk Engine",
        "desc": "Predicts disruptions before they happen.",
        "icon": Icons.auto_awesome,
      },
      {
        "title": "Micro Premiums",
        "desc": "Start at ₹69/week.",
        "icon": Icons.currency_rupee,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Why Paymigo",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: features.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final f = features[index];

              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(f["icon"] as IconData,
                        color: Colors.orange),
                    const SizedBox(height: 12),
                    Text(
                      f["title"] as String,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      f["desc"] as String,
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}