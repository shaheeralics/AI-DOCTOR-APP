import 'package:flutter/material.dart';
import 'doctor_card.dart';
import '../models/doctor_model.dart';

class DoctorList extends StatefulWidget {
  final List<Doctor> doctors;
  final bool isLoading;

  const DoctorList({
    Key? key,
    required this.doctors,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList>
    with SingleTickerProviderStateMixin {
  late AnimationController _listAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animation
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00B4D8),
        ),
      );
    }

    if (widget.doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No doctors found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _listAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: 2, // Further reduced from 4
              bottom: 12, // Further reduced from 16
            ),
            itemCount: widget.doctors.length,
            itemBuilder: (context, index) {
              return DoctorCard(
                doctor: widget.doctors[index],
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}
