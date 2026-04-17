import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widget.dart';
import '../screens/dashboard_screen.dart';
import '../screens/plans_screen.dart';
class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Glow accents
                Text(
                  'Ready to ',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingBlack.copyWith(fontSize: 34),
                ),
                GradientText(
                  'Shield Your Income?',
                  style: AppTextStyles.headingBlack.copyWith(fontSize: 34),
                ),
                const SizedBox(height: 20),
                Text(
                  "Join thousands of delivery partners who no longer fear the monsoon. Get your first week of GigKavach for just ₹1.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 36),
                AccentButton(
  label: 'Start Your Protection',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  },
),
                const SizedBox(height: 16),
                GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlansScreen(),
      ),
    );
  },
  child: Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 28, vertical: 16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: const Text(
      'View All Plans',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
    ),
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shield, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'Paymigo',
                style: AppTextStyles.headingBlack.copyWith(fontSize: 28),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "India's first AI-powered parametric income insurance platform for food delivery partners. Protecting the backbone of the digital economy.",
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 36),

          // Links
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FooterLinks(
                  heading: 'PLATFORM',
                  links: [
                    'How it Works',
                    'Pricing Plans',
                    'AI & ML Stack',
                    'For Insurers'
                  ],
                ),
              ),
              Expanded(
                child: _FooterLinks(
                  heading: 'COMPANY',
                  links: [
                    'About Us',
                    'Careers',
                    'Privacy Policy',
                    'Terms of Service'
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 36),
          const Divider(color: AppColors.border),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '© 2026 Paymigo Technologies Pvt Ltd.',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Operational',
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final String heading;
  final List<String> links;

  const _FooterLinks({required this.heading, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              link,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}