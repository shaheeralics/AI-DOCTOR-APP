import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../utils/constants.dart';
import 'voice_message_ui.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;

  const ChatInput({
    Key? key,
    required this.messageController,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _hasText = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    widget.messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = widget.messageController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.messageController.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Voice Message UI (shown when recording)
        if (_isRecording)
          VoiceMessageUI(
            onCancel: () {
              setState(() {
                _isRecording = false;
              });
            },
            onSend: () {
              setState(() {
                _isRecording = false;
              });
              // Handle voice message send
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice message sent!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onLock: () {
              // Handle voice message lock
            },
          ),
        
        // Regular chat input
        if (!_isRecording)
          Container(
            decoration: BoxDecoration(
              color: kCardBackground,
              boxShadow: [
                BoxShadow(
                  color: kMedicalBlue.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    // Attachment Button
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          // Show attachment options
                          _showAttachmentOptions(context);
                        },
                        icon: Icon(
                          Ionicons.add,
                          color: kPrimaryColor,
                          size: 16,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Message Input Field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kBackgroundColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: kMedicalBlue.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: widget.messageController,
                                maxLines: null,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(
                                    color: kPrimaryColor.withOpacity(0.6),
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Montserrat',
                                ),
                                onSubmitted: (_) => widget.onSendMessage(),
                              ),
                            ),
                            
                            // Emoji Button
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              onPressed: () {
                                // Show emoji picker
                              },
                              icon: Icon(
                                Ionicons.happy_outline,
                                color: kPrimaryColor,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Send Button / Voice Button
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: _hasText ? kMedicalGradient : null,
                        color: _hasText ? null : kMedicalBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _hasText ? [
                          BoxShadow(
                            color: kMedicalBlue.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: _hasText ? widget.onSendMessage : () {
                          // Start voice recording UI
                          setState(() {
                            _isRecording = true;
                          });
                        },
                        icon: Icon(
                          _hasText ? Ionicons.send : Ionicons.mic,
                          color: _hasText ? Colors.white : kMedicalBlue,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.3), // Use login screen colors
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Share Your Medical Records',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: kPrimaryColor, // Use login screen colors
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Attachment Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Ionicons.camera,
                  label: 'Camera',
                  color: kSecondaryColor, // Use login screen blue
                  onTap: () {
                    Navigator.pop(context);
                    // Camera functionality
                  },
                ),
                _buildAttachmentOption(
                  icon: Ionicons.images,
                  label: 'Gallery',
                  color: kSecondaryColor, // Use login screen blue
                  onTap: () {
                    Navigator.pop(context);
                    // Gallery functionality
                  },
                ),
                _buildAttachmentOption(
                  icon: Ionicons.document,
                  label: 'Document',
                  color: kSecondaryColor, // Use login screen blue
                  onTap: () {
                    Navigator.pop(context);
                    // Document functionality
                  },
                ),
                
              ],
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: kPrimaryColor, // Use login screen colors
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
