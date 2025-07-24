import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../utils/constants.dart';
import '../../doctor_selection_screen/models/doctor_model.dart';
import 'doctor_details_modal.dart';

class ChatAppBar extends StatelessWidget {
  final String doctorName;
  final bool isOnline;
  final Doctor? doctor;

  const ChatAppBar({
    Key? key,
    required this.doctorName,
    required this.isOnline,
    this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: kMedicalGradient, // Use medical gradient
        boxShadow: [
          BoxShadow(
            color: kMedicalBlue.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Back Button
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Ionicons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Doctor Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Ionicons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Doctor Info - Clickable Area
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (doctor != null) {
                      DoctorDetailsModal.show(context, doctor!);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                doctorName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                            if (doctor != null)
                              Icon(
                                Ionicons.information_circle_outline,
                                color: Colors.white.withOpacity(0.7),
                                size: 16,
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isOnline ? Colors.green : Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isOnline ? 'Online' : 'Offline',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.8),
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Action Buttons
              IconButton(
                onPressed: () {
                  // Video call functionality
                },
                icon: const Icon(
                  Ionicons.videocam,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              IconButton(
                onPressed: () {
                  // Voice call functionality
                },
                icon: const Icon(
                  Ionicons.call,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              IconButton(
                onPressed: () {
                  // More options
                },
                icon: const Icon(
                  Ionicons.ellipsis_vertical,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
