import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_theme.dart';
import '../sections/hero_section.dart';
import '../sections/features_section.dart';
import '../sections/stats_section.dart';
import '../sections/live_claim_widget.dart';

// 🔥 NEW SCREENS
import '../screens/wallet_add_screen.dart';
import '../screens/claim_submit_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final isScrolled = _scrollController.offset > 50;
      if (isScrolled != _scrolled) {
        setState(() => _scrolled = isScrolled);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔥 DRAWER
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.shield, color: Colors.orange, size: 40),
              const SizedBox(height: 10),
              const Text("Paymigo",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),

              menuItem(context, Icons.home, "Home", "/"),
              menuItem(context, Icons.info, "How it Works", "/how-it-works"),
              menuItem(context, Icons.star, "Plans", "/plans"),

              const Spacer(),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout"),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (route) => false);
                },
              ),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [

          /// 🔥 MAIN CONTENT (APP STYLE)
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: const [
                HeroSection(),

                /// 🔥 LIVE ACTIVITY
                LiveClaimWidget(),

                /// 🔥 ACTIONS
                _QuickActions(),

                /// 🔥 MINI DASHBOARD
                StatsSection(),

                /// 🔥 FEATURES
                FeaturesSection(),
              ],
            ),
          ),

          /// 🔥 NAVBAR
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: _NavBar(scrolled: _scrolled),
          ),
        ],
      ),
    );
  }

  Widget menuItem(
      BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}

///////////////////////////////////////////////////////////
/// 🔥 QUICK ACTIONS (FIXED)
///////////////////////////////////////////////////////////

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          actionCard(context, Icons.flash_on, "Claim"),
          const SizedBox(width: 12),
          actionCard(context, Icons.account_balance_wallet, "Wallet"),
          const SizedBox(width: 12),
          actionCard(context, Icons.workspace_premium, "Plans"),
        ],
      ),
    );
  }

  Widget actionCard(BuildContext context, IconData icon, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {

          /// 🔐 LOGIN CHECK
          final user = FirebaseAuth.instance.currentUser;

          if (user == null) {
            Navigator.pushNamed(context, "/login");
            return;
          }

          /// 🔥 ROUTING
          if (label == "Wallet") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WalletAddScreen(),
              ),
            );
          }

          else if (label == "Claim") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ClaimSubmitScreen(),
              ),
            );
          }

          else if (label == "Plans") {
            Navigator.pushNamed(context, "/plans");
          }
        },

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.orange),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// 🔥 NAVBAR
///////////////////////////////////////////////////////////

class _NavBar extends StatelessWidget {
  final bool scrolled;
  const _NavBar({required this.scrolled});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
              )
            ],
          ),
          child: Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),

              const Icon(Icons.shield, color: Colors.orange),
              const SizedBox(width: 6),

              const Expanded(
                child: Text(
                  "Paymigo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, "/dashboard");
                  } else {
                    Navigator.pushNamed(context, "/login");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text(user != null ? "Dashboard" : "Get Started"),
              ),
            ],
          ),
        );
      },
    );
  }
}