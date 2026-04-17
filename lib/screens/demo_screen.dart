import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  VideoPlayerController? controller;

  bool isPlaying = false;
  bool isGenerating = false;
  bool showOverlay = true;

  final String videoUrl =
       "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

  /// 🔥 AI LOADING MESSAGES
  final List<String> messages = [
    "Connecting to weather satellites...",
    "Calibrating rainfall sensors...",
    "Analyzing payout data...",
    "Triggering smart contract...",
    "Processing instant payout...",
    "Generating AI demo..."
  ];

  String currentMessage = "";

  /// 🎬 GENERATE DEMO
  void generateDemo() async {
    setState(() {
      isGenerating = true;
    });

    int index = 0;

    /// 🔥 LOOP MESSAGES LIKE AI
    Future.doWhile(() async {
      if (!isGenerating) return false;

      setState(() {
        currentMessage = messages[index % messages.length];
      });

      index++;
      await Future.delayed(const Duration(seconds: 2));
      return isGenerating;
    });

    /// simulate API delay
    await Future.delayed(const Duration(seconds: 6));

    controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          isGenerating = false;
          showOverlay = false;
          isPlaying = true;
        });
        controller!.play();
      });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("AI Demo")),

      body: Column(
        children: [

          /// 🎥 VIDEO AREA
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              children: [

                /// VIDEO
                if (controller != null &&
                    controller!.value.isInitialized)
                  VideoPlayer(controller!)
                else
                  Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(Icons.shield,
                          size: 80, color: Colors.orange),
                    ),
                  ),

                /// ▶ PLAY OVERLAY
                if (showOverlay && !isGenerating)
                  GestureDetector(
                    onTap: generateDemo,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.play_circle_fill,
                              size: 80, color: Colors.orange),
                          SizedBox(height: 10),
                          Text(
                            "Generate AI Demo",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                /// 🔄 LOADING OVERLAY
                if (isGenerating)
                  Container(
                    color: Colors.black.withOpacity(0.85),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                              color: Colors.orange),
                          const SizedBox(height: 20),
                          Text(
                            currentMessage,
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 🎮 VIDEO CONTROLS
          if (controller != null && controller!.value.isInitialized)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPlaying) {
                        controller!.pause();
                      } else {
                        controller!.play();
                      }
                      isPlaying = !isPlaying;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.replay, color: Colors.white),
                  onPressed: () {
                    controller!.seekTo(Duration.zero);
                    controller!.play();
                  },
                ),
              ],
            ),

          const SizedBox(height: 20),

          /// ⚡ HOW IT WORKS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                StepCard(
                  title: "Real-time Monitoring",
                  desc: "AI tracks weather data continuously",
                ),
                StepCard(
                  title: "Automatic Trigger",
                  desc: "Threshold reached → system activates",
                ),
                StepCard(
                  title: "Instant Payout",
                  desc: "Money sent instantly to wallet",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 STEP CARD
class StepCard extends StatelessWidget {
  final String title;
  final String desc;

  const StepCard({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(desc, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}