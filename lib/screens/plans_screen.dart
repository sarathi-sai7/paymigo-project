import 'package:flutter/material.dart';
import 'plan_checkout_screen.dart';
class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool isMonsoon = false;
  String selectedCity = "Coimbatore";

  int getBasePrice() {
    if (selectedCity.contains("Coimbatore")) return 49;
    if (selectedCity.contains("Chennai") ||
        selectedCity.contains("Mumbai")) return 149;
    return 119;
  }

  @override
  Widget build(BuildContext context) {
    final basePrice = getBasePrice();

    final plans = [
      {
        "name": "Basic",
        "price": 49 + (isMonsoon ? 30 : 0),
        "features": [
          "Rainfall > 25mm/hr",
          "AQI > 400",
          "4-hour payout",
        ]
      },
      {
        "name": "Pro",
        "price": 69 + (isMonsoon ? 30 : 0),
        "recommended": true,
        "features": [
          "Rainfall > 15mm/hr",
          "90-sec payout",
          "Fuel Cashback",
        ]
      },
      {
        "name": "Premium",
        "price": 119 + (isMonsoon ? 40 : 0),
        "features": [
          "Rainfall > 10mm/hr",
          "Instant payout",
          "Max benefits",
        ]
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Plans")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🌧 MONSOON TOGGLE
            SwitchListTile(
              value: isMonsoon,
              onChanged: (val) {
                setState(() => isMonsoon = val);
              },
              title: const Text("Monsoon Mode"),
            ),

            const SizedBox(height: 10),

            /// 🌍 CITY SELECT
            DropdownButtonFormField(
              value: selectedCity,
              dropdownColor: Colors.black,
              items: ["Coimbatore", "Chennai", "Mumbai", "Bangalore"]
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() => selectedCity = val.toString());
              },
              decoration: const InputDecoration(
                labelText: "Select City",
              ),
            ),

            const SizedBox(height: 20),

            /// 💰 ESTIMATOR
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text("Estimated Weekly Premium",
                      style: TextStyle(color: Colors.orange)),
                  Text(
                    "₹$basePrice",
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 📦 PLANS
            Column(
              children: plans.map((plan) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: plan["recommended"] == true
                          ? Colors.orange
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// TITLE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(plan["name"].toString(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          if (plan["recommended"] == true)
                            const Text("Recommended",
                                style: TextStyle(color: Colors.orange))
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// PRICE
                      Text(
                        "₹${plan["price"]}/wk",
                        style: const TextStyle(
                            fontSize: 24, color: Colors.white),
                      ),

                      const SizedBox(height: 10),

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

                      const SizedBox(height: 15),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                         onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PlanCheckoutScreen(planId: "basic"),
    ),
  );
},
                          child: const Text("Select Plan"),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}