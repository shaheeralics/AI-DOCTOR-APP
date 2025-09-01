import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../utils/constants.dart';
import '../../doctor_selection_screen/models/doctor_model.dart';
import 'doctor_details_modal.dart';
import '../../call_screen/call_screen.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Size get preferredSize => const Size.fromHeight(75);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                  size: 20,
                ),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
              ),
              
              const SizedBox(width: 2),
              
              // Doctor Avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Ionicons.person,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              
              const SizedBox(width: 6),
              
              // Doctor Info - Clickable Area
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (doctor != null) {
                      DoctorDetailsModal.show(context, doctor!);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (doctor != null)
                              Icon(
                                Ionicons.information_circle_outline,
                                color: Colors.white.withOpacity(0.7),
                                size: 14,
                              ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isOnline ? Colors.green : Colors.grey,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isOnline ? 'Online' : 'Offline',
                              style: TextStyle(
                                fontSize: 9,
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
                  size: 18,
                ),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
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
                  size: 18,
                ),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
              ),
              
              IconButton(
                onPressed: () {
                  // More options
                },
                icon: const Icon(
                  Ionicons.ellipsis_vertical,
                  color: Colors.white,
                  size: 16,
                ),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
