import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../utils/constants.dart';

class DoctorSelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DoctorSelectionAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(90); // Reduced from 100

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90, // Reduced from 100
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00B4D8), // Medical Blue
            kSecondaryColor, // Your existing blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), // Reduced padding
          child: Row(
            children: [
              // Back Button with Animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Ionicons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Title with Slide Animation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(50 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: const Text(
                              'Choose Your Specialist',
                              style: TextStyle(
                                fontSize: 18, // Reduced from 20
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(30 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: Text(
                              'Select the right doctor for your needs',
                              style: TextStyle(
                                fontSize: 11, // Reduced from 12
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Medical Icon with Pulse Animation
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 2000),
                tween: Tween<double>(begin: 0.8, end: 1.2),
                curve: Curves.easeInOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Ionicons.medical,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  );
                },
                onEnd: () {
                  // Repeat animation
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
