import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  String? error;
  String mode = "login";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// 🔥 EMAIL AUTH
  Future<void> handleAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => error = "Enter valid credentials");
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      if (mode == "login") {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      await navigateUser();

    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// 🔥 GOOGLE SIGN IN
  Future<void> handleGoogleSignIn() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() => error = "Google sign-in cancelled");
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      await navigateUser();

    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// 🔥 STRICT ONBOARDING CHECK (FINAL)
  Future<void> navigateUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("workers")
        .doc(user.uid)
        .get();

    final isOnboarded =
        doc.exists && doc.data()?["onboardingComplete"] == true;

    if (!mounted) return;

    if (!isOnboarded) {
      Navigator.pushReplacementNamed(context, "/onboard");
    } else {
      Navigator.pushReplacementNamed(context, "/dashboard");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [

              const SizedBox(height: 60),

              /// 🔥 LOGO
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.shield,
                    color: Colors.orange, size: 40),
              ),

              const SizedBox(height: 12),

              const Text(
                "Paymigo",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              const Text(
                "Smart Protection for Gig Workers",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// 🔥 TOGGLE
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    toggleBtn("login", "Login"),
                    toggleBtn("signup", "Sign Up"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 GOOGLE
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : handleGoogleSignIn,
                  icon: const Icon(Icons.g_mobiledata,
                      color: Colors.red),
                  label: const Text("Continue with Google"),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              if (error != null)
                Text(error!,
                    style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 10),

              buildInput(emailController, "Email"),
              const SizedBox(height: 12),
              buildInput(passwordController, "Password",
                  isPassword: true),

              const SizedBox(height: 20),

              /// 🔥 MAIN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : Text(
                          mode == "login"
                              ? "Login"
                              : "Create Account",
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 TOGGLE BUTTON
  Widget toggleBtn(String value, String text) {
    final selected = mode == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => mode = value),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? Colors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 INPUT FIELD
  Widget buildInput(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}