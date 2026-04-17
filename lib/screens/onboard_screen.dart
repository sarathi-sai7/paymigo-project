import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int step = 1;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String selectedZone = "Coimbatore";
  String selectedPlan = "Pro";

  bool isLoading = false;

  /// 🔥 FINAL NEXT BUTTON (FIXED)
  void next() async {
    if (step == 1 &&
        (nameController.text.isEmpty ||
            phoneController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter all details")),
      );
      return;
    }

    if (step == 4) {
      setState(() => isLoading = true);

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        /// ✅ 1. SAVE FIRESTORE FIRST
        await FirebaseFirestore.instance
            .collection("workers")
            .doc(user.uid)
            .set({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "city": selectedZone,
          "zone": selectedZone,
          "plan": selectedPlan, 
          "onboardingComplete": true,
        }, SetOptions(merge: true));

        /// ✅ 2. NAVIGATE IMMEDIATELY (NO BLOCK)
        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          "/dashboard",
          (route) => false,
        );

        /// 🔥 3. BACKEND CALLS (NON-BLOCKING)
        ApiService.createWorker(
          firebaseUid: user.uid,
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
        );

        ApiService.updateProfile(
          uid: user.uid,
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          city: selectedZone,
        );

      } catch (e) {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }

      return;
    }

    setState(() => step++);
  }

  void back() {
    if (step > 1) setState(() => step--);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,

          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.shield, color: Colors.orange),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Paymigo",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text("Step $step / 4",
                      style: const TextStyle(
                          fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              LinearProgressIndicator(
                value: step / 4,
                color: Colors.orange,
                backgroundColor: Colors.grey[200],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: SingleChildScrollView(
                    key: ValueKey(step),
                    child: buildStep(),
                  ),
                ),
              ),

              Row(
                children: [
                  if (step > 1)
                    TextButton(
                      onPressed: back,
                      child: const Text("Back",
                          style: TextStyle(color: Colors.grey)),
                    ),

                  const Spacer(),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize:
                            const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : Text(
                              step == 4
                                  ? "Finish Setup"
                                  : "Continue",
                            ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔁 STEP SWITCH
  Widget buildStep() {
    switch (step) {
      case 1:
        return step1();
      case 2:
        return step2();
      case 3:
        return step3();
      case 4:
        return step4();
      default:
        return Container();
    }
  }

  Widget step1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Welcome 👋",
            style:
                TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        buildInput(nameController, "Full Name"),
        const SizedBox(height: 10),
        buildInput(phoneController, "Phone Number"),
      ],
    );
  }

  Widget step2() {
    final zones = ["Coimbatore", "Chennai", "Bangalore", "Mumbai"];
    return Column(children: zones.map((z) => zoneCard(z)).toList());
  }

  Widget zoneCard(String z) {
    final selected = selectedZone == z;

    return GestureDetector(
      onTap: () => setState(() => selectedZone = z),
      child: buildCard(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(z),
            if (selected)
              const Icon(Icons.check_circle, color: Colors.orange)
          ],
        ),
        highlight: selected,
      ),
    );
  }

  Widget step3() {
    final plans = [
      {"name": "Basic", "price": 49},
      {"name": "Pro", "price": 69},
      {"name": "Premium", "price": 119},
    ];

    return Column(
      children: plans.map((p) => planCard(p)).toList(),
    );
  }

  Widget planCard(Map p) {
    final selected = selectedPlan == p["name"];

    return GestureDetector(
      onTap: () => setState(() => selectedPlan = p["name"]),
      child: buildCard(
        Text("${p["name"]} - ₹${p["price"]}"),
        highlight: selected,
      ),
    );
  }

  Widget step4() {
    return Column(
      children: [
        buildCard(
          Column(
            children: [
              const Text(
                "Confirm Details",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Name: ${nameController.text}"),
              Text("Phone: ${phoneController.text}"),
              Text("Zone: $selectedZone"),
              Text("Plan: $selectedPlan"),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCard(Widget child, {bool highlight = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.orange.withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
        border:
            highlight ? Border.all(color: Colors.orange) : null,
      ),
      child: child,
    );
  }

  Widget buildInput(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}