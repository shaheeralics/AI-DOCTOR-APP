import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../utils/constants.dart';

import 'components/center_widget/center_widget.dart';
import 'components/login_content.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    
    // Background gradient animation
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _backgroundColorAnimation = ColorTween(
      begin: kBackgroundColor,
      end: kBackgroundGradientEnd,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    _backgroundAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  Widget topWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 1.2 * screenWidth,
        height: 1.2 * screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: LinearGradient(
            begin: const Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [
              kMedicalBlue.withOpacity(0.3),
              kMedicalBlueLight.withOpacity(0.7),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomWidget(double screenWidth) {
    return Container(
      width: 1.5 * screenWidth,
      height: 1.5 * screenWidth,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: const Alignment(0.6, -1.1),
          end: const Alignment(0.7, 0.8),
          colors: [
            kMedicalBlue.withOpacity(0.8),
            kMedicalBlueLight.withOpacity(0.1),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _backgroundColorAnimation.value ?? kBackgroundColor,
                  kBackgroundGradientEnd,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -160,
                  left: -30,
                  child: topWidget(screenSize.width),
                ),
                Positioned(
                  bottom: -180,
                  left: -40,
                  child: bottomWidget(screenSize.width),
                ),
                CenterWidget(size: screenSize),
                const LoginContent(),
              ],
            ),
          ),
        );
      },
    );
  }
}
