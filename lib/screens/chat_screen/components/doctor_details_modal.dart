import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../utils/constants.dart';
import '../../doctor_selection_screen/models/doctor_model.dart';

class DoctorDetailsModal extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsModal({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kMedicalBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Doctor Profile Section
              _buildDoctorProfile(),
              
              const SizedBox(height: 24),
              
              // Quick Stats
              _buildQuickStats(),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              _buildActionButtons(context),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorProfile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: kMedicalGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kMedicalBlue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Doctor Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: const Icon(
              Ionicons.person,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Doctor Name
          Text(
            doctor.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Specialty
          Text(
            doctor.specialty,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontFamily: 'Montserrat',
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: doctor.isAvailable ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                doctor.isAvailable ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Ionicons.star,
            title: 'Specialty',
            value: doctor.specialty,
            subtitle: doctor.availabilityText,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Ionicons.time,
            title: 'Status',
            value: doctor.isAvailable ? 'Online' : 'Offline',
            subtitle: doctor.isAvailable ? 'Available' : 'Not Available',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Ionicons.people,
            title: 'Tags',
            value: doctor.tags.isNotEmpty ? doctor.tags.first : 'General',
            subtitle: 'Category',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kMedicalBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kMedicalBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: kMedicalBlue,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: kTextSecondary,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kMedicalBlue,
              fontFamily: 'Montserrat',
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              color: kTextSecondary,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Ionicons.videocam,
            label: 'Video Call',
            color: kMedicalBlue,
            onTap: () {
              Navigator.pop(context);
              // Video call functionality
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Ionicons.call,
            label: 'Voice Call',
            color: kSecondaryColor,
            onTap: () {
              Navigator.pop(context);
              // Voice call functionality
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Ionicons.calendar,
            label: 'Schedule',
            color: Colors.orange,
            onTap: () {
              Navigator.pop(context);
              // Schedule appointment
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, Doctor doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DoctorDetailsModal(doctor: doctor),
    );
  }
}
