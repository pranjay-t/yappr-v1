import 'package:flutter/material.dart';
import 'package:yappr/core/Theme/app_pallete.dart';
import 'package:yappr/core/constants/message_bubble.dart';

class MessageListView extends StatelessWidget {
  final List messages;
  final Set<String> selectedMessages;
  final Function toggleSelection;
  final String currUser;

  const MessageListView({super.key, 
    required this.messages,
    required this.selectedMessages,
    required this.toggleSelection,
    required this.currUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        final message = messages[index];
        final isSelected = selectedMessages.contains(message.messageId);
        final isCurrentUser = message.senderId == currUser;

        return GestureDetector(
          onLongPress: () => toggleSelection(message.messageId, message.senderId, currUser),
          onTap: () {
            if (selectedMessages.isNotEmpty) {
              toggleSelection(message.messageId, message.senderId, currUser);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: isSelected ? AppPallete.secondaryColor : Colors.transparent,
            child: MessageBubble(
              message: message.message,
              isCurrentUser: isCurrentUser,
            ),
          ),
        );
      },
    );
  }
}