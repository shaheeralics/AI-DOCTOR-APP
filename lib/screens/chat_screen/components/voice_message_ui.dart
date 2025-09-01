import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:math' as math;

class VoiceMessageUI extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSend;
  final VoidCallback? onLock;
  final VoidCallback? onRecordingStart;
  final VoidCallback? onRecordingStop;

  const VoiceMessageUI({
    Key? key,
    this.onCancel,
    this.onSend,
    this.onLock,
    this.onRecordingStart,
    this.onRecordingStop,
  }) : super(key: key);

  @override
  State<VoiceMessageUI> createState() => _VoiceMessageUIState();
}

class _VoiceMessageUIState extends State<VoiceMessageUI>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _lockController;
  late AnimationController _waveController;
  late AnimationController _trashController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _lockAnimation;
  late Animation<Color?> _micColorAnimation;
  late Animation<double> _trashAnimation;
  
  bool _isLocked = false;
  bool _isRecording = false;
  double _horizontalDrag = 0;
  double _verticalDrag = 0;
  String _recordingTime = "0:00";
  int _recordingSeconds = 0;
  List<double> _waveData = [];
  
  // WhatsApp-style colors
  static const Color _whatsappGreen = Color(0xFF25D366);
  static const Color _whatsappGray = Color(0xFF8696A0);
  static const Color _deleteRed = Color(0xFFE53E3E);
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startRecording();
  }
  
  void _initializeAnimations() {
    // Pulsing microphone animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Slide animation for cancel/lock detection
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
    
    // Lock animation
    _lockController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _lockAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lockController, curve: Curves.elasticOut),
    );
    
    // Microphone color animation
    _micColorAnimation = ColorTween(
      begin: _whatsappGreen,
      end: _deleteRed,
    ).animate(_slideController);
    
    // Waveform animation
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    // Trash animation
    _trashController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _trashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _trashController, curve: Curves.easeInOut),
    );
  }
  
  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    
    widget.onRecordingStart?.call();
    _pulseController.repeat(reverse: true);
    _startTimer();
    _generateWaveData();
    HapticFeedback.lightImpact();
  }
  
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingSeconds++;
          int minutes = _recordingSeconds ~/ 60;
          int seconds = _recordingSeconds % 60;
          _recordingTime = "$minutes:${seconds.toString().padLeft(2, '0')}";
        });
        _startTimer();
      }
    });
  }
  
  void _generateWaveData() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isRecording && mounted) {
        setState(() {
          // Generate more controlled wave data to prevent overflow
          // Values between 0.3 and 0.9 for better visual consistency
          double amplitude = 0.3 + (math.Random().nextDouble() * 0.6);
          _waveData.add(amplitude);
          if (_waveData.length > 25) { // Reduced from 30 to prevent too many bars
            _waveData.removeAt(0);
          }
        });
        _waveController.forward().then((_) {
          _waveController.reset();
        });
        _generateWaveData();
      }
    });
  }
  
  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isLocked) return;
    
    setState(() {
      _horizontalDrag += details.delta.dx;
      _verticalDrag += details.delta.dy;
    });
    
    // Handle horizontal drag for cancel
    if (_horizontalDrag < -30) {
      _slideController.forward();
      _trashController.forward();
      HapticFeedback.selectionClick();
    } else {
      _slideController.reverse();
      _trashController.reverse();
    }
    
    // Handle vertical drag for lock
    if (_verticalDrag < -50) {
      _lockController.forward();
      HapticFeedback.lightImpact();
    } else {
      _lockController.reverse();
    }
  }
  
  void _handlePanEnd(DragEndDetails details) {
    if (_isLocked) return;
    
    if (_horizontalDrag < -80) {
      // Cancel recording
      _cancelRecording();
    } else if (_verticalDrag < -80) {
      // Lock recording
      _lockRecording();
    } else {
      // Send recording
      _sendRecording();
    }
    
    _resetDragState();
  }
  
  void _lockRecording() {
    setState(() {
      _isLocked = true;
    });
    _lockController.forward();
    HapticFeedback.mediumImpact();
    widget.onLock?.call();
  }
  
  void _cancelRecording() {
    _stopRecording();
    HapticFeedback.heavyImpact();
    widget.onCancel?.call();
  }
  
  void _sendRecording() {
    _stopRecording();
    HapticFeedback.lightImpact();
    widget.onSend?.call();
  }
  
  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    widget.onRecordingStop?.call();
    _pulseController.stop();
  }
  
  void _resetDragState() {
    setState(() {
      _horizontalDrag = 0;
      _verticalDrag = 0;
    });
    _slideController.reverse();
    _trashController.reverse();
    if (!_isLocked) {
      _lockController.reverse();
    }
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _lockController.dispose();
    _waveController.dispose();
    _trashController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _isLocked ? 100 : 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: _isLocked ? _buildLockedUI() : _buildRecordingUI(),
      ),
    );
  }
  
  Widget _buildRecordingUI() {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Stack(
        children: [
          // Background with slide effect
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.red.withOpacity(_slideAnimation.value * 0.1),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
              );
            },
          ),
          
          // Main recording content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                // Recording dot and time
                Row(
                  children: [
                    // Pulsing red dot
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Recording time
                    Text(
                      _recordingTime,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8696A0),
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 20),
                
                // Waveform visualization
                Expanded(
                  child: ClipRect(
                    child: _buildWaveform(),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Slide indicators
                _buildSlideIndicators(),
                
                const SizedBox(width: 16),
                
                // Microphone button
                _buildMicrophoneButton(),
              ],
            ),
          ),
          
          // Lock indicator (top)
          AnimatedBuilder(
            animation: _lockAnimation,
            builder: (context, child) {
              return Positioned(
                top: 10 - (_lockAnimation.value * 20),
                right: 70,
                child: Opacity(
                  opacity: _lockAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _whatsappGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Ionicons.lock_closed,
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Slide up to lock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildWaveform() {
    return ClipRect(
      child: SizedBox(
        height: 24, // Even smaller fixed height
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _waveData.map((amplitude) {
                // Very conservative height - max 16px in 24px container
                double barHeight = (amplitude * 12).clamp(2.0, 16.0);
                return Container(
                  width: 2,
                  height: barHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  decoration: BoxDecoration(
                    color: _whatsappGreen,
                    borderRadius: BorderRadius.circular(1),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSlideIndicators() {
    return Row(
      children: [
        // Cancel indicator (trash)
        AnimatedBuilder(
          animation: _trashAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_trashAnimation.value * -20, 0),
              child: Opacity(
                opacity: 0.3 + (_trashAnimation.value * 0.7),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _deleteRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Ionicons.trash,
                    color: _deleteRed,
                    size: 16,
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(width: 8),
        
        // Arrow indicators
        Opacity(
          opacity: 0.5,
          child: Row(
            children: [
              Icon(
                Ionicons.chevron_back,
                color: _whatsappGray,
                size: 12,
              ),
              Text(
                'Slide to cancel',
                style: TextStyle(
                  color: _whatsappGray,
                  fontSize: 10,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMicrophoneButton() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _micColorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _micColorAnimation.value,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_micColorAnimation.value ?? _whatsappGreen).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Ionicons.mic,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildLockedUI() {
    return Column(
      children: [
        // Top section with lock indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _whatsappGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Ionicons.lock_closed,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Recording locked',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Cancel button
              GestureDetector(
                onTap: _cancelRecording,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _deleteRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Ionicons.trash,
                    color: _deleteRed,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Bottom section with waveform and controls
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Recording time
                Text(
                  _recordingTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8696A0),
                    fontFamily: 'Montserrat',
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Waveform
                Expanded(
                  child: ClipRect(
                    child: _buildWaveform(),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Send button
                GestureDetector(
                  onTap: _sendRecording,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _whatsappGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _whatsappGreen.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Ionicons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
