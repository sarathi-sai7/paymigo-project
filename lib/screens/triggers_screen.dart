import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';
import '../models/trigger_model.dart';

class TriggersScreen extends StatefulWidget {
  const TriggersScreen({super.key});

  @override
  State<TriggersScreen> createState() => _TriggersScreenState();
}

class _TriggersScreenState extends State<TriggersScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  TriggerModel? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTriggers();
  }

  Future<void> loadTriggers() async {
    try {
      final res = await ApiService.getTriggers(uid);
if (!mounted) return;

setState(() {
  data = TriggerModel.fromJson(res);
  loading = false;
});
    } catch (e) {
      print("Trigger error: $e");
      setState(() => loading = false);
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "PAYOUT_TRIGGERED":
        return Colors.red;
      case "WARNING":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Live Weather Risk"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: loadTriggers,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// 🔥 STATUS CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: getStatusColor(data!.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    data!.status.replaceAll("_", " "),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(data!.status),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Zone: ${data!.zone}"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 METRICS
            buildCard("Rainfall", "${data!.rainfall} mm", Icons.water_drop),
            buildCard("Wind Speed", "${data!.windSpeed} km/h", Icons.air),
            buildCard("Water Logging", "${data!.waterLogging}", Icons.flood),

            const SizedBox(height: 20),

            /// 🔥 REFRESH BUTTON
            ElevatedButton(
              onPressed: loadTriggers,
              child: const Text("Refresh"),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}