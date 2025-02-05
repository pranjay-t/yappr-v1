import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yappr/core/Theme/app_pallete.dart';
import 'package:yappr/core/constants/error_text.dart';
import 'package:yappr/features/auths/controller/auth_controller.dart';
import 'package:yappr/features/chat/controller/chat_controller.dart';
import 'package:yappr/features/chat/screens/pages/edit_message.dart';
import 'package:yappr/Resposive/responsive.dart';
import 'package:yappr/core/commons/loader.dart';
import 'package:yappr/features/chat/screens/widgets/message_input.dart';
import 'package:yappr/features/chat/screens/widgets/message_listview.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final String receiverId;

  const MessageScreen({super.key, required this.receiverId});

  @override
  ConsumerState createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final messageController = TextEditingController();
  Set<String> selectedMessages = {};

  void sendMessage(BuildContext context) {
    String messageContent = messageController.text.trim();
    if (messageContent.isEmpty) return;
    final chatController = ref.read(chatControllerProvider);
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    chatController.createMessage(
      context: context,
      receiverId: widget.receiverId,
      message: messageContent,
      timestamp: timestamp,
    );
    messageController.clear();
  }

  void deleteMessages() {
    if (selectedMessages.isEmpty) return;
    final chatController = ref.read(chatControllerProvider);
    chatController.deleteMessages(
      context: context,
      receiverId: widget.receiverId,
      senderId: ref.read(userProvider)!.uid,
      messageIds: selectedMessages.toList(),
    );
    setState(() => selectedMessages.clear());
  }

  void toggleSelection(String messageId, String senderId, String currUser) {
    if (senderId != currUser) return;
    setState(() {
      if (selectedMessages.contains(messageId)) {
        selectedMessages.remove(messageId);
      } else {
        selectedMessages.add(messageId);
      }
    });
  }

  bool get isAnySelected => selectedMessages.isNotEmpty;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currUser = ref.read(userProvider)!.uid;
    return ref.read(getUserDataProvider(widget.receiverId)).when(
          data: (user) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 19, 18, 18),
              appBar: AppBar(
                titleSpacing: -2,
                title: isAnySelected
                    ? null
                    : Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(user.name),
                        ],
                      ),
                leading: IconButton(
                  onPressed: () {
                    if (isAnySelected) {
                      setState(() => selectedMessages.clear());
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    isAnySelected ? Icons.close : Icons.arrow_back,
                    size: 35,
                  ),
                ),
                actions: [
                  if (isAnySelected)
                    Row(
                      children: [
                        Text(
                          selectedMessages.length.toString(),
                          style: TextStyle(
                              fontSize: 26,
                              color: AppPallete.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: deleteMessages,
                          icon: const Icon(Icons.delete_outline,
                              size: 30, color: AppPallete.errorColor),
                        ),
                        if (selectedMessages.length == 1)
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMessage(
                                    messageId: selectedMessages.first,
                                    senderId: currUser,
                                    receiverId: widget.receiverId,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 30,
                              color: AppPallete.primaryColor,
                            ),
                          ),
                      ],
                    )
                ],
              ),
              body: ref.watch(getMessageProvider(user.uid)).when(
                    data: (messages) {
                      return Center(
                        child: Responsive(
                          child: Column(
                            children: [
                              Expanded(
                                child: MessageListView(
                                  messages: messages,
                                  selectedMessages: selectedMessages,
                                  toggleSelection: toggleSelection,
                                  currUser: currUser,
                                ),
                              ),
                              MessageInput(
                                messageController: messageController,
                                sendMessage: sendMessage,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader(),
                  ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}