import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widget.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 400;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 70, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF8F5), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 LIVE BADGE
          FadeTransition(
            opacity: _fadeIn,
            child: const LiveBadge(label: 'Live: Protection Active'),
          ),

          const SizedBox(height: 14),

          /// 🔥 HEADLINE (COMPACT)
          SlideTransition(
            position: _slideIn,
            child: FadeTransition(
              opacity: _fadeIn,
              child: Text(
                "Protect your income instantly",
                style: AppTextStyles.displayBlack.copyWith(
                  fontSize: isMobile ? 24 : 28,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          /// 🔥 SUBTEXT (SHORT)
          FadeTransition(
            opacity: _fadeIn,
            child: Text(
              "AI-triggered payouts in 90 seconds.",
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// 🔥 PRIMARY BUTTON
          FadeTransition(
            opacity: _fadeIn,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: AccentButton(
                label: 'Shield Your Income',
                icon: const Icon(Icons.arrow_forward,
                    color: Colors.white, size: 18),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 🔥 SECONDARY ACTIONS
          FadeTransition(
            opacity: _fadeIn,
            child: Row(
              children: [

                Expanded(
                  child: OutlineButton2(
                    label: 'View Plans',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/demo");
                    },
                    child: OutlineButton2(
                      label: 'AI Demo',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          /// 🔥 MINI STATUS CARD (APP FEEL)
          FadeTransition(
            opacity: _fadeIn,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.flash_on, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "AI monitoring your zone in real-time",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}