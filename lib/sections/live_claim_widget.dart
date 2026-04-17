import 'package:flutter/material.dart';

class LiveClaimWidget extends StatelessWidget {
  const LiveClaimWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [

            /// 🔥 ICON
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.flash_on, color: Colors.orange),
            ),

            const SizedBox(width: 12),

            /// 🔥 TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Live Claim Triggered",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Rainfall detected • ₹1,500 credited",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            /// 🔥 STATUS ICON
            const Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }
}