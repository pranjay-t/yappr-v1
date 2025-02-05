import 'package:flutter/material.dart';
import 'package:yappr/core/Theme/app_pallete.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController messageController;
  final Function sendMessage;

  const MessageInput({super.key, 
    required this.messageController,
    required this.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: const TextStyle(fontSize: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              onSubmitted: (value) => sendMessage(context),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => sendMessage(context),
            child: CircleAvatar(
              backgroundColor: AppPallete.primaryColor,
              radius: 28,
              child: const Icon(
                Icons.send,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}