import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:yappr/core/constants/utils.dart';
import 'package:yappr/features/auths/controller/auth_controller.dart';
import 'package:yappr/features/chat/repository/chat_repository.dart';
import 'package:yappr/models/message_model.dart';
import 'package:yappr/models/usermodel.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

final fetchAllUsersProvider = StreamProvider((ref) {
  final chatController = ref.watch(chatControllerProvider);
  return chatController.fetchAllUsers();
});

final getMessageProvider = StreamProvider.family((ref, String receiverId) {
  final chatController = ref.watch(chatControllerProvider);
  return chatController.getMessages(receiverId);
});

class ChatController {
  final ChatRepository _chatRepository;
  final Ref _ref;
  ChatController({
    required ChatRepository chatRepository,
    required Ref ref,
  })  : _chatRepository = chatRepository,
        _ref = ref;

  void createMessage({
    required BuildContext context,
    required String receiverId,
    required String message,
    required String timestamp,
  }) {
    final userId = _ref.read(userProvider)!.uid;
    final messageId = const Uuid().v4();

    try {
      _chatRepository.createMessage(
        newMessage: Message(
          messageId: messageId,
          senderId: userId,
          receiverId: receiverId,
          message: message,
          timestamp: timestamp,
        ),
        senderId: userId,
        receiverId: receiverId,
      );
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message ?? 'An unknown error occurred');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void updateMessage({
    required BuildContext context,
    required String messageId,
    required String newMessageContent,
    required String senderId,
    required String receiverId,
  }) {
    try {
      _chatRepository.updateMessage(
        messageId: messageId,
        newMessageContent: newMessageContent,
        senderId: senderId,
        receiverId: receiverId,
      );
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message ?? 'An unknown error occurred');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void deleteMessages({
    required BuildContext context,
    required String receiverId,
    required String senderId,
    required List<String> messageIds,
  }) {
    try {
      _chatRepository.deleteMessages(
        senderId: senderId,
        receiverId: receiverId,
        messageIds: messageIds,
      );
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message ?? 'An unknown error occurred');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Stream<List<UserModel>> fetchAllUsers() {
    return _chatRepository.fetchAllUsers();
  }

  Stream<List<Message>> getMessages(String receiverId) {
    final senderId = _ref.read(userProvider)!.uid;
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    // print(senderId);
    // print(receiverId);
    return _chatRepository.getMessages(chatRoomId);
  }
}
