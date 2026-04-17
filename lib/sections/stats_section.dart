import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widget.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  static const List<Map<String, String>> _stats = [
    {'val': '5M+', 'label': 'Target Partners'},
    {'val': '₹12Cr+', 'label': 'Claims Capacity'},
    {'val': '99.9%', 'label': 'AI Accuracy'},
    {'val': '1.2k', 'label': 'Micro-Zones'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Stack(
        children: [
          // Glow blobs
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentSecondary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Stats grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _stats.length,
            itemBuilder: (context, i) {
              final stat = _stats[i];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientText(
                    stat['val']!,
                    style: AppTextStyles.displayBlack.copyWith(fontSize: 42),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stat['label']!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelUppercase.copyWith(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 9,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}