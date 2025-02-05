import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yappr/core/Theme/app_pallete.dart';
import 'package:yappr/features/chat/controller/chat_controller.dart';

class EditMessage extends ConsumerStatefulWidget {
  final String messageId;
  final String senderId;
  final String receiverId;

  const EditMessage({
    super.key,
    required this.messageId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  ConsumerState<EditMessage> createState() => _EditMessageState();
}

class _EditMessageState extends ConsumerState<EditMessage> {
  final TextEditingController _messageController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void updateMessage(BuildContext context) {
    final chatController = ref.read(chatControllerProvider);
    chatController.updateMessage(
      context: context,
      messageId: widget.messageId,
      newMessageContent: _messageController.text.trim(),
      senderId: widget.senderId,
      receiverId: widget.receiverId,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 35,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Message",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'carter',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your new message',
                        hintStyle: const TextStyle(
                          fontFamily: 'carter',
                          fontSize: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                      ),
                      onSubmitted: (value) =>
                                            _isEditing ? updateMessage(context) : null,
                      onChanged: (value) {
                        setState(() {
                          _isEditing = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _isEditing ? updateMessage(context) : null,
                    child: CircleAvatar(
                      backgroundColor:
                          _isEditing ? AppPallete.primaryColor : Colors.grey,
                      radius: 28,
                      child: const Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
