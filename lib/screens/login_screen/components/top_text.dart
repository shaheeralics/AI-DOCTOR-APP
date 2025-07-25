import 'package:flutter/material.dart';
import 'package:login_screen/screens/login_screen/animations/change_screen_animation.dart';
import 'package:login_screen/utils/helper_functions.dart';

import 'login_content.dart';

class TopText extends StatefulWidget {
  const TopText({Key? key}) : super(key: key);

  @override
  State<TopText> createState() => _TopTextState();
}

class _TopTextState extends State<TopText> {
  @override
  void initState() {
    ChangeScreenAnimation.topTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Take full available width
      height: 160, // Increased from 120 to 160 to accommodate all content
      padding: const EdgeInsets.symmetric(horizontal: 24), // Add padding for the left text
      child: Column(
        children: [
          // AI DOCTOR - Perfectly centered

          const Text(
            'AI',
            style: TextStyle(
                fontSize:28,
                fontWeight: FontWeight.bold,
                color : Color.fromARGB(255, 2, 119, 203)
            ),
            
          ),
          const Center(
            child:  Text(
              'DOCTOR',
              style:  TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 180, 216)
              ),
            ),
          ),
          const SizedBox(height: 35), // Space between the texts
          // Create Account / Welcome Back - Left aligned within the padded container
          Align(
            alignment: Alignment.center,
            child: HelperFunctions.wrapWithAnimatedBuilder(
              animation: ChangeScreenAnimation.topTextAnimation,
              child: Text(
                ChangeScreenAnimation.currentScreen == Screens.createAccount
                    ? 'Create Account'
                    : 'Welcome Back',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
