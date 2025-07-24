import 'package:flutter/material.dart';
import '../chat_screen.dart';
import '../../../utils/constants.dart';

class ChatMessages extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;

  const ChatMessages({
    Key? key,
    required this.messages,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent, // Transparent to show gradient background
      ),
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ChatBubble(message: message);
        },
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isMe 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          // Doctor Avatar (only for doctor messages)
          if (!message.isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: kCardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: kMedicalBlue.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kMedicalBlue.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.person,
                color: kMedicalBlue,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          // Message Bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe 
                    ? kMedicalBlue  // User messages - medical blue
                    : kCardBackground,    // Doctor messages - white like cards
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: message.isMe 
                      ? const Radius.circular(18) 
                      : const Radius.circular(4),
                  bottomRight: message.isMe 
                      ? const Radius.circular(4) 
                      : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: message.isMe 
                        ? kMedicalBlue.withOpacity(0.2)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe 
                          ? Colors.white 
                          : kTextPrimary,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isMe 
                          ? Colors.white.withOpacity(0.7) 
                          : kTextSecondary,
                      fontSize: 11,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // User Avatar (only for user messages)
          if (message.isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: kMedicalGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: kMedicalBlue.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
