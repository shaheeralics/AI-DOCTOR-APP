import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:math' as math;
import '../../utils/constants.dart';
import '../doctor_selection_screen/models/doctor_model.dart';
import 'components/sound_wave_widget.dart';

class CallScreen extends StatefulWidget {
  final Doctor doctor;
  final bool isVideoCall;

  const CallScreen({
    Key? key,
    required this.doctor,
    this.isVideoCall = false,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    with TickerProviderStateMixin {
  late AnimationController _doctorVibrateController;
  late AnimationController _userVibrateController;
  late AnimationController _backgroundController;
  late AnimationController _callDurationController;
  late AnimationController _breathingController;
  
  late Animation<double> _doctorVibrateAnimation;
  late Animation<double> _userVibrateAnimation;
  late Animation<Color?> _backgroundAnimation;
  late Animation<double> _breathingAnimation;
  
  bool _isDoctorSpeaking = false;
  bool _isUserSpeaking = false;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  String _callDuration = "00:00";
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _doctorVibrateController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _userVibrateController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _callDurationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    // Initialize animations
    _doctorVibrateAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _doctorVibrateController,
      curve: Curves.easeInOut,
    ));
    
    _userVibrateAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _userVibrateController,
      curve: Curves.elasticInOut,
    ));
    
    _backgroundAnimation = ColorTween(
      begin: kBackgroundColor,
      end: kMedicalBlue.withOpacity(0.05),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    _breathingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    // Start background animation
    _backgroundController.repeat(reverse: true);
    _breathingController.repeat(reverse: true);
    
    // Start call duration timer
    _startCallTimer();
    
    // Simulate conversation
    _simulateConversation();
  }
  
  void _startCallTimer() {
    int seconds = 0;
    _callDurationController.addListener(() {
      if (_callDurationController.isCompleted) {
        seconds++;
        int minutes = seconds ~/ 60;
        int remainingSeconds = seconds % 60;
        setState(() {
          _callDuration = "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
        });
        _callDurationController.reset();
        _callDurationController.forward();
      }
    });
    _callDurationController.forward();
  }
  
  bool _isCallActive = true;
  bool _isCallEnding = false;

  void _simulateConversation() {
    // Simulate a realistic medical conversation pattern
    if (_isCallActive) {
      Future.delayed(const Duration(seconds: 2), () {
        if (_isCallActive) _startDoctorSpeaking();
      });
    }
  }
  
  void _startDoctorSpeaking() {
    if (!_isCallActive) return;
    
    setState(() {
      _isDoctorSpeaking = true;
      _isUserSpeaking = false;
    });
    _doctorVibrateController.repeat(reverse: true);
    
    // Doctor speaks for 3-5 seconds with medical context
    Future.delayed(Duration(seconds: 3 + math.Random().nextInt(3)), () {
      if (_isCallActive) {
        _stopDoctorSpeaking();
        
        // Short pause before user responds
        Future.delayed(const Duration(milliseconds: 800), () {
          if (_isCallActive) _startUserSpeaking();
        });
      }
    });
  }
  
  void _startUserSpeaking() {
    if (!_isCallActive) return;
    
    setState(() {
      _isUserSpeaking = true;
      _isDoctorSpeaking = false;
    });
    _userVibrateController.repeat(reverse: true);
    
    // User speaks for 2-4 seconds
    Future.delayed(Duration(seconds: 2 + math.Random().nextInt(3)), () {
      if (_isCallActive) {
        _stopUserSpeaking();
        
        // Short pause before doctor responds
        Future.delayed(Duration(milliseconds: 1000 + math.Random().nextInt(1000)), () {
          if (_isCallActive) _startDoctorSpeaking();
        });
      }
    });
  }
  
  void _endCall() {
    setState(() {
      _isCallEnding = true;
    });
    
    _isCallActive = false;
    _stopDoctorSpeaking();
    _stopUserSpeaking();
    
    // Small delay to show ending animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
  
  void _stopDoctorSpeaking() {
    setState(() {
      _isDoctorSpeaking = false;
    });
    _doctorVibrateController.stop();
    _doctorVibrateController.reset();
  }
  
  void _stopUserSpeaking() {
    setState(() {
      _isUserSpeaking = false;
    });
    _userVibrateController.stop();
    _userVibrateController.reset();
  }

  @override
  void dispose() {
    _doctorVibrateController.dispose();
    _userVibrateController.dispose();
    _backgroundController.dispose();
    _callDurationController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _backgroundAnimation.value ?? kBackgroundColor,
                  kMedicalBlue.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header with call info
                  _buildCallHeader(),
                  
                  // Main speaking area
                  Expanded(
                    child: _buildSpeakingArea(),
                  ),
                  
                  // Control buttons
                  _buildControlButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCallHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Reduced padding
      child: Column(
        children: [
          Text(
            widget.isVideoCall ? 'Video Call' : 'Voice Call',
            style: TextStyle(
              fontSize: 14, // Reduced from 16
              color: kTextSecondary,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 6), // Reduced from 8
          Text(
            widget.doctor.name,
            style: const TextStyle(
              fontSize: 20, // Reduced from 24
              fontWeight: FontWeight.bold,
              color: kMedicalBlue,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 2), // Reduced from 4
          Text(
            widget.doctor.specialty,
            style: TextStyle(
              fontSize: 12, // Reduced from 14
              color: kTextSecondary,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8), // Reduced from 12
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Reduced padding
            decoration: BoxDecoration(
              color: kMedicalBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16), // Reduced from 20
            ),
            child: Text(
              _callDuration,
              style: const TextStyle(
                fontSize: 14, // Reduced from 16
                fontWeight: FontWeight.w600,
                color: kMedicalBlue,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSpeakingArea() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Doctor speaking circle
            AnimatedBuilder(
              animation: Listenable.merge([_doctorVibrateAnimation, _breathingAnimation]),
              builder: (context, child) {
                double scale = _isDoctorSpeaking 
                    ? _doctorVibrateAnimation.value 
                    : _breathingAnimation.value;
                return Transform.scale(
                  scale: scale,
                  child: _buildSpeakingCircle(
                    isDoctor: true,
                    isSpeaking: _isDoctorSpeaking,
                    name: "Dr. ${widget.doctor.name.split(' ').last}",
                  ),
                );
              },
            ),
            
            // Speaking indicator
            _buildSpeakingIndicator(),
            
            // User speaking circle
            AnimatedBuilder(
              animation: Listenable.merge([_userVibrateAnimation, _breathingAnimation]),
              builder: (context, child) {
                double scale = _isUserSpeaking 
                    ? _userVibrateAnimation.value 
                    : _breathingAnimation.value;
                return Transform.scale(
                  scale: scale,
                  child: _buildSpeakingCircle(
                    isDoctor: false,
                    isSpeaking: _isUserSpeaking,
                    name: "You",
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSpeakingCircle({
    required bool isDoctor,
    required bool isSpeaking,
    required String name,
  }) {
    return Column(
      children: [
        // Ripple effect container
        Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ripples when speaking (reduced size)
            PulseRippleWidget(
              isActive: isSpeaking,
              color: isDoctor ? kMedicalBlue : kSecondaryColor,
              size: 100, // Reduced from 120
            ),
            
            // Main speaking circle (reduced size)
            Container(
              width: 100, // Reduced from 120
              height: 100, // Reduced from 120
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSpeaking
                    ? (isDoctor ? kMedicalGradient : LinearGradient(
                        colors: [kSecondaryColor, kMedicalBlueLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ))
                    : null,
                color: isSpeaking ? null : kCardBackground,
                border: Border.all(
                  color: isSpeaking 
                      ? (isDoctor ? kMedicalBlue : kSecondaryColor)
                      : kMedicalBlue.withOpacity(0.3),
                  width: isSpeaking ? 3 : 2, // Reduced border width
                ),
                boxShadow: isSpeaking ? [
                  BoxShadow(
                    color: (isDoctor ? kMedicalBlue : kSecondaryColor).withOpacity(0.3),
                    blurRadius: 15, // Reduced shadow
                    spreadRadius: 3, // Reduced shadow
                  ),
                ] : [
                  BoxShadow(
                    color: kMedicalBlue.withOpacity(0.1),
                    blurRadius: 8, // Reduced shadow
                    spreadRadius: 1, // Reduced shadow
                  ),
                ],
              ),
              child: Icon(
                isDoctor ? Ionicons.medical : Ionicons.person,
                size: 40, // Reduced from 50
                color: isSpeaking ? Colors.white : kMedicalBlue,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Sound waves when speaking (reduced size)
        SoundWaveWidget(
          isActive: isSpeaking,
          color: isDoctor ? kMedicalBlue : kSecondaryColor,
          size: 60, // Reduced from 80
        ),
        
        const SizedBox(height: 8),
        
        Text(
          name,
          style: TextStyle(
            fontSize: 14, // Reduced from 16
            fontWeight: isSpeaking ? FontWeight.bold : FontWeight.w500,
            color: isSpeaking ? kMedicalBlue : kTextSecondary,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }
  
  Widget _buildSpeakingIndicator() {
    String statusText = "Listening...";
    Color statusColor = kTextSecondary;
    
    if (_isCallEnding) {
      statusText = "Call ending...";
      statusColor = Colors.red;
    } else if (_isDoctorSpeaking) {
      statusText = "Doctor is speaking...";
      statusColor = kMedicalBlue;
    } else if (_isUserSpeaking) {
      statusText = "You are speaking...";
      statusColor = kSecondaryColor;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced padding
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20), // Reduced from 25
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, // Reduced from 8
            height: 6, // Reduced from 8
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6), // Reduced from 8
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12, // Reduced from 14
              color: statusColor,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Reduced vertical padding
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mute button
            _buildControlButton(
              icon: _isMuted ? Ionicons.mic_off : Ionicons.mic,
              isActive: _isMuted,
              color: _isMuted ? Colors.red : kMedicalBlue,
              onTap: () {
                setState(() {
                  _isMuted = !_isMuted;
                });
              },
            ),
            
            // End call button
            _buildControlButton(
              icon: Ionicons.call,
              isActive: true,
              color: Colors.red,
              size: 60, // Reduced from 70
              onTap: _endCall,
            ),
            
            // Speaker button
            _buildControlButton(
              icon: _isSpeakerOn ? Ionicons.volume_high : Ionicons.volume_low,
              isActive: _isSpeakerOn,
              color: _isSpeakerOn ? kSecondaryColor : kMedicalBlue,
              onTap: () {
                setState(() {
                  _isSpeakerOn = !_isSpeakerOn;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
    double size = 60,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive ? color : kCardBackground,
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : color,
          size: size * 0.4,
        ),
      ),
    );
  }
}
