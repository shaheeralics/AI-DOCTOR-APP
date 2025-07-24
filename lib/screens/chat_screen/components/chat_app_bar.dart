import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../utils/constants.dart';
import '../../doctor_selection_screen/models/doctor_model.dart';
import 'doctor_details_modal.dart';
import '../../call_screen/call_screen.dart';

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
      height: 90, // Reduced from 100
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Reduced padding
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
                  size: 22, // Reduced from 24
                ),
                padding: const EdgeInsets.all(8), // Reduced padding
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
              
              const SizedBox(width: 4), // Reduced from default spacing
              
              // Doctor Avatar
              Container(
                width: 36, // Reduced from 40
                height: 36, // Reduced from 40
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18), // Adjusted for new size
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Ionicons.person,
                  color: Colors.white,
                  size: 18, // Reduced from 20
                ),
              ),
              
              const SizedBox(width: 8), // Reduced from 12
              
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
                                  fontSize: 12, // Reduced from 13
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
                  if (doctor != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          doctor: doctor!,
                          isVideoCall: true,
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Ionicons.videocam,
                  color: Colors.white,
                  size: 20, // Reduced from 24
                ),
                padding: const EdgeInsets.all(8), // Reduced padding
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
              
              IconButton(
                onPressed: () {
                  if (doctor != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          doctor: doctor!,
                          isVideoCall: false,
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Ionicons.call,
                  color: Colors.white,
                  size: 20, // Reduced from 24
                ),
                padding: const EdgeInsets.all(8), // Reduced padding
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
              
              IconButton(
                onPressed: () {
                  // More options
                },
                icon: const Icon(
                  Ionicons.ellipsis_vertical,
                  color: Colors.white,
                  size: 18, // Reduced from 20
                ),
                padding: const EdgeInsets.all(8), // Reduced padding
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
