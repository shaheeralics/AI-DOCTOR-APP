import 'package:flutter/material.dart';
import 'components/chat_app_bar.dart';
import 'components/chat_messages.dart';
import 'components/chat_input.dart';
import '../../utils/constants.dart';
import '../doctor_selection_screen/models/doctor_model.dart';

class ChatScreen extends StatefulWidget {
  final Doctor? selectedDoctor;
  
  const ChatScreen({Key? key, this.selectedDoctor}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  
  late AnimationController _backgroundAnimationController;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    
    // Background animation like doctor selection
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
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
    
    // Add some sample messages
    _addSampleMessages();
  }

  void _addSampleMessages() {
    _messages.addAll([
      ChatMessage(
        text: "Hello! How can I help you today?",
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        text: "Hi Doctor! I have been feeling unwell recently.",
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      ChatMessage(
        text: "I'm sorry to hear that. Can you describe your symptoms?",
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      ChatMessage(
        text: "I have a headache and mild fever since yesterday.",
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ]);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text.trim(),
          isMe: true,
          timestamp: DateTime.now(),
        ));
      });
      _messageController.clear();
      
      // Auto scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get doctor info from selected doctor or use default
    final doctorName = widget.selectedDoctor?.name ?? "Dr. AI";
    final isOnline = widget.selectedDoctor?.isAvailable ?? true;
    
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
            child: Column(
              children: [
                // Custom App Bar
                ChatAppBar(
                  doctorName: doctorName,
                  isOnline: isOnline,
                  doctor: widget.selectedDoctor,
                ),
                
                // Messages Area
                Expanded(
                  child: ChatMessages(
                    messages: _messages,
                    scrollController: _scrollController,
                  ),
                ),
                
                // Input Area
                ChatInput(
                  messageController: _messageController,
                  onSendMessage: _sendMessage,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Chat Message Model
class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
