import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';
import '../widgets/rain_chart.dart';
import 'wallet_screen.dart';
import 'claims_screen.dart';
import 'profile_screen.dart';
import 'ai_models_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<double> rainHistory = [2, 4, 6, 8, 10];
  String activeTab = "dashboard";

  double rainfall = 0;
  double windSpeed = 0;
  double waterLogging = 0;
  String status = "MONITORING";

  bool payoutTriggered = false; // 🔥 prevent duplicate calls

  @override
  void initState() {
    super.initState();
    fetchTriggers();
  }

  /// 🔥 FETCH DATA FROM BACKEND
  Future<void> fetchTriggers() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final data = await ApiService.getTriggers(user.uid);

      setState(() {
        rainfall = (data["rainfall"] ?? 0).toDouble();
        windSpeed = (data["windSpeed"] ?? 0).toDouble();
        waterLogging = (data["waterLogging"] ?? 0).toDouble();
        status = data["status"] ?? "MONITORING";

        rainHistory.add(rainfall);
        if (rainHistory.length > 6) {
          rainHistory.removeAt(0);
        }
      });

      /// 🔥 BACKEND AUTO PAYOUT TRIGGER
      if (status == "PAYOUT_TRIGGERED" && !payoutTriggered) {
        payoutTriggered = true;

        await ApiService.triggerPayout(
          uid: user.uid,
          rainfall: rainfall,
          threshold: 15,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("⚡ Auto payout triggered"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

    } catch (e) {
      print("❌ Trigger error: $e");
    }
  }

  /// 🔥 STATUS COLOR
  Color getStatusColor() {
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
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔥 APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield,
                  color: Colors.orange, size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Paymigo",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text("Smart Insurance",
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),

      /// 🔥 DRAWER
      drawer: Drawer(
        child: SafeArea(child: buildSidebar()),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: buildContent(),
      ),
    );
  }

  /// 🔥 SIDEBAR
  Widget buildSidebar() {
    return Column(
      children: [
        const SizedBox(height: 20),

        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            FirebaseAuth.instance.currentUser?.email ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("Active User"),
        ),

        const Divider(),

        Expanded(
          child: ListView(
            children: [
              navItem("dashboard", "Overview", Icons.dashboard),
              navItem("ai", "AI Engine", Icons.auto_awesome),
              navItem("wallet", "Wallet", Icons.account_balance_wallet),
              navItem("claims", "Claims", Icons.receipt_long),
              navItem("profile", "Profile", Icons.person),
            ],
          ),
        ),

        navItem("logout", "Logout", Icons.logout),
      ],
    );
  }

  Widget navItem(String id, String title, IconData icon) {
    final isActive = activeTab == id;

    return ListTile(
      tileColor: isActive ? Colors.orange.withOpacity(0.1) : null,
      onTap: () async {
        if (id == "logout") {
          await FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
          return;
        }

        setState(() => activeTab = id);
        Navigator.pop(context);
      },
      leading: Icon(icon,
          color: isActive ? Colors.orange : Colors.grey),
      title: Text(title),
    );
  }

  /// 🔁 CONTENT SWITCH
  Widget buildContent() {
    switch (activeTab) {
      case "profile":
        return const ProfileScreen();
      case "wallet":
        return const WalletScreen();
      case "claims":
        return const ClaimsScreen();
      case "ai":
        return const AIModelsScreen();
      default:
        return buildDashboard();
    }
  }

  /// 🔥 DASHBOARD UI
  Widget buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 STATUS CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.bolt, color: getStatusColor()),
                const SizedBox(width: 10),
                Text(
                  status.replaceAll("_", " "),
                  style: TextStyle(
                    color: getStatusColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 🔥 STATS
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              statCard("Rainfall", "$rainfall mm",
                  color: rainfall > 15 ? Colors.red : Colors.green),
              statCard("Wind", "$windSpeed km/h",
                  color: windSpeed > 40 ? Colors.orange : Colors.green),
              statCard("Water", "$waterLogging cm"),
            ],
          ),

          const SizedBox(height: 20),

          const Text("Rainfall Trend"),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: RainChart(data: rainHistory),
          ),
        ],
      ),
    );
  }

  /// 🔥 STAT CARD
  Widget statCard(String title, String value, {Color? color}) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey[100])!.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color ?? Colors.grey)),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color ?? Colors.black)),
        ],
      ),
    );
  }
}