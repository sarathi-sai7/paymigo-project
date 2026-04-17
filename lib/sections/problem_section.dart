import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widget.dart';

class ProblemSection extends StatelessWidget {
  const ProblemSection({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
bool isMobile = width < 400;
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Headline
          Text(
            "Rain shouldn't mean",
            style: AppTextStyles.headingBlack.copyWith(fontSize: 36),
          ),
          GradientText(
            'Zero Earnings.',
            style: AppTextStyles.headingBlack.copyWith(fontSize: 36),
          ),
          const SizedBox(height: 20),

          Text(
            'A single monsoon week can wipe out 40% of a delivery partner\'s monthly income. Traditional insurance is too slow. Paymigo is parametric—meaning we pay based on real-time weather data, not damage claims.',
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 32),

          // Feature list
          ...[
            {
              'title': 'Real-time Weather Monitoring',
              'desc': 'Hyper-local data from 1,200+ micro-zones.'
            },
            {
              'title': 'Zero Paperwork',
              'desc': 'No claim forms. No phone calls. No waiting.'
            },
            {
              'title': 'Instant Wallet Credit',
              'desc': 'Money hits your Paymigo wallet in 90 seconds.'
            },
          ].map((item) => _FeatureRow(
                title: item['title']!,
                desc: item['desc']!,
              )),

          SizedBox(height: isMobile ? 30 : 48),

          // Weekly loss tracker card
          const _WeeklyLossTracker(),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String title;
  final String desc;

  const _FeatureRow({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.check_circle, color: AppColors.accent, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyLossTracker extends StatefulWidget {
  const _WeeklyLossTracker();

  @override
  State<_WeeklyLossTracker> createState() => _WeeklyLossTrackerState();
}

class _WeeklyLossTrackerState extends State<_WeeklyLossTracker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _barAnims;

  final List<Map<String, dynamic>> _days = [
    {'day': 'Mon', 'loss': 0, 'status': 'Clear'},
    {'day': 'Tue', 'loss': 450, 'status': 'Rain'},
    {'day': 'Wed', 'loss': 800, 'status': 'Storm'},
    {'day': 'Thu', 'loss': 600, 'status': 'Rain'},
    {'day': 'Fri', 'loss': 0, 'status': 'Clear'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _barAnims = List.generate(_days.length, (i) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.1, 0.5 + i * 0.1, curve: Curves.easeOutBack),
        ),
      );
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY LOSS TRACKER',
                style: AppTextStyles.labelUppercase.copyWith(fontSize: 10),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ALERT: HEAVY RAIN',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 20),

          // Day rows
          ..._days.asMap().entries.map((entry) {
            final i = entry.key;
            final d = entry.value;
            final loss = d['loss'] as int;
            final fraction = loss > 0 ? loss / 800.0 : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text(
                        d['day'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _barAnims[i],
                        builder: (context, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 10,
                              color: Colors.white,
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor:
                                    fraction * _barAnims[i].value,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.accent,
                                        AppColors.accentSecondary
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 64,
                      child: Text(
                        loss > 0 ? '-₹$loss' : 'Clear',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          fontFamily: 'monospace',
                          color: loss > 0 ? AppColors.danger : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          // Total saved
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'TOTAL LOSS AVOIDED',
                  style: AppTextStyles.labelUppercase.copyWith(
                    color: AppColors.accent,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 8),
                GradientText(
                  '₹1,850',
                  style: AppTextStyles.displayBlack.copyWith(fontSize: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}