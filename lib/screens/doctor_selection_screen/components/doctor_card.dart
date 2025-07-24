import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../utils/constants.dart';
import '../models/doctor_model.dart';
import '../../chat_screen/chat_screen.dart';

class DoctorCard extends StatefulWidget {
  final Doctor doctor;
  final int index;

  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.index,
  }) : super(key: key);

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Staggered animation based on index
    Future.delayed(Duration(milliseconds: 200 + (widget.index * 150)), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getSpecialtyIcon(String specialty) {
    switch (specialty.toLowerCase()) {
      case 'ent specialist':
        return Ionicons.ear;
      case 'cardiologist':
        return Ionicons.heart;
      case 'neurologist':
        return Ionicons.skull; // Using skull as brain alternative
      case 'dermatologist':
        return Ionicons.body;
      case 'orthopedic surgeon':
        return Ionicons.fitness;
      default:
        return Ionicons.medical;
    }
  }

  void _onCardTap() {
    // Navigation to chat screen with selected doctor
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChatScreen(selectedDoctor: widget.doctor),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: AnimatedScale(
                scale: _isPressed ? 0.95 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed = true),
                  onTapUp: (_) => setState(() => _isPressed = false),
                  onTapCancel: () => setState(() => _isPressed = false),
                  onTap: _onCardTap,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                        BoxShadow(
                          color: const Color(0xFF00B4D8).withOpacity(0.1),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Doctor Avatar with Animation
                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 1500),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          builder: (context, double value, child) {
                            return Transform.rotate(
                              angle: value * 0.1,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF00B4D8),
                                      kSecondaryColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kSecondaryColor.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getSpecialtyIcon(widget.doctor.specialty),
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 16),

                        // Doctor Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Doctor Name
                              Text(
                                widget.doctor.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              
                              const SizedBox(height: 4),
                              
                              // Specialty with colored background
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00B4D8).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.doctor.specialty,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF00B4D8),
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 6),
                              
                              // Description
                              Text(
                                widget.doctor.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontFamily: 'Montserrat',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Availability Status
                              Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 1000),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: widget.doctor.isAvailable
                                          ? Colors.green
                                          : Colors.orange,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.doctor.availabilityText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: widget.doctor.isAvailable
                                          ? Colors.green[700]
                                          : Colors.orange[700],
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Start Chat Button with Animation
                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 2000),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: 0.8 + (0.2 * value),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF00B4D8),
                                      kSecondaryColor,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kSecondaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Ionicons.chatbubble,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Start Chat',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
