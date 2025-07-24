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
        color: Color.fromARGB(255, 231, 236, 237), // Same mint green background as login screen
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
          if (!message.isMe) ...[
            // Doctor avatar for received messages
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(78, 207, 214, 0.562).withOpacity(0.1), // Same blue as login button
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color.fromARGB(146, 38, 136, 171).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Color.fromARGB(165, 38, 129, 171), // Same blue as login button
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
                    ? const Color.fromARGB(255, 78, 209, 185)  // User messages - same blue as login button
                    : Colors.white,    // Doctor messages - white like login input fields
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
                    color: Colors.black.withOpacity(0.08), // Same shadow as login elements
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message Text
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: message.isMe 
                          ? Colors.white 
                          : const Color.fromARGB(255, 45, 110, 112), // Same dark color as login screen text
                      fontFamily: 'Montserrat', // Same font as login screen
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Timestamp
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: message.isMe 
                              ? Colors.white.withOpacity(0.7)
                              : const Color.fromARGB(255, 116, 186, 213).withOpacity(0.6), // Same as login screen hint colors
                          fontFamily: 'Montserrat', // Same font as login screen
                        ),
                      ),
                      
                      if (message.isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          if (message.isMe) ...[
            const SizedBox(width: 8),
            // User avatar for sent messages
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1), // Same dark color as login screen
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: kPrimaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: kPrimaryColor, // Same dark color as login screen
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
