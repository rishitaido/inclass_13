// lib/screens/success_screen.dart
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';

class SuccessScreen extends StatefulWidget {
  final String userName;
  final IconData avatarIcon;
  final List<String> achievements;

  const SuccessScreen({
    super.key,
    required this.userName,
    required this.avatarIcon,
    required this.achievements,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Stack(
        children: [
          // Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.deepPurple,
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.orange,
              ],
            ),
          ),
          
          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.avatarIcon,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Personalized Welcome Message
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome, ${widget.userName}! 🎉',
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
                  const SizedBox(height: 20),
                  
                  const Text(
                    'Your adventure begins now!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  

                  if (widget.achievements.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.emoji_events, color: Colors.amber, size: 30),
                              SizedBox(width: 8),
                              Text(
                                'Achievements Unlocked!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...widget.achievements.map((achievement) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: _buildAchievementBadge(achievement),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                  
                  // More Celebration Button
                  ElevatedButton(
                    onPressed: () {
                      _confettiController.play();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'More Celebration! 🎊',
                      style: TextStyle(fontSize: 16, color: Colors.white),
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

  Widget _buildAchievementBadge(String achievement) {
    IconData badgeIcon;
    Color badgeColor;

    // Assign icons and colors based on achievement
    if (achievement.contains('Strong Password')) {
      badgeIcon = Icons.security;
      badgeColor = Colors.green;
    } else if (achievement.contains('Early Bird')) {
      badgeIcon = Icons.wb_sunny;
      badgeColor = Colors.orange;
    } else if (achievement.contains('Profile Completer')) {
      badgeIcon = Icons.check_circle;
      badgeColor = Colors.blue;
    } else {
      badgeIcon = Icons.star;
      badgeColor = Colors.purple;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, color: badgeColor, size: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              achievement,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}