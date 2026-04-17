import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  bool isEditing = false;
  bool loading = true;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController cityController;

  String selectedPlan = "";

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController =
        TextEditingController(text: user?.email ?? "");
    phoneController = TextEditingController();
    cityController = TextEditingController();

    loadUserData();
  }

  /// 🔥 LOAD DATA (BACKEND FIRST)
  Future<void> loadUserData() async {
    if (user == null) return;

    try {
      final data = await ApiService.getProfile(user!.uid);

      if (!mounted) return;

      setState(() {
        nameController.text = data["name"] ?? "";
        phoneController.text = data["phone"] ?? "";
        cityController.text = data["city"] ?? "";
        selectedPlan = data["plan"] ?? "";
        loading = false;
      });

    } catch (e) {

      /// 🔥 FALLBACK FIRESTORE
      final doc = await FirebaseFirestore.instance
          .collection("workers")
          .doc(user!.uid)
          .get();

      if (!mounted) return;

      if (doc.exists) {
        final data = doc.data()!;

        setState(() {
          nameController.text = data["name"] ?? "";
          phoneController.text = data["phone"] ?? "";
          cityController.text = data["city"] ?? "";
          selectedPlan = data["plan"] ?? "";
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    }
  }

  /// 🔥 SAVE PROFILE
  Future<void> saveProfile() async {
    if (user == null) return;

    try {
      /// BACKEND
      await ApiService.updateProfile(
        uid: user!.uid,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
      );

      /// FIRESTORE SYNC
      await FirebaseFirestore.instance
          .collection("workers")
          .doc(user!.uid)
          .set({
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "city": cityController.text.trim(),
        "plan": selectedPlan,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated ✅")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// 🔥 HEADER CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Text(
                        nameController.text.isEmpty
                            ? "U"
                            : nameController.text[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameController.text.isEmpty
                                ? "User"
                                : nameController.text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            emailController.text,
                            style: const TextStyle(
                                color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: Icon(
                        isEditing ? Icons.check : Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (isEditing) {
                          await saveProfile();
                        }
                        setState(() => isEditing = !isEditing);
                      },
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 FIELDS
              buildField(Icons.person, "Name", nameController),
              buildField(Icons.phone, "Phone", phoneController),
              buildField(Icons.location_on, "City", cityController),
              buildField(Icons.email, "Email", emailController,
                  enabled: false),

              const SizedBox(height: 20),

              /// 🔥 PLAN CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium,
                        color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        selectedPlan.isEmpty
                            ? "No Plan"
                            : selectedPlan,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text("Active",
                        style: TextStyle(color: Colors.orange))
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// 🔥 LOGOUT
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Logout",
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 FIELD UI
  Widget buildField(IconData icon, String label,
      TextEditingController controller,
      {bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: isEditing && enabled,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}