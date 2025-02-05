import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:yappr/core/constants/failure.dart';
import 'package:yappr/core/constants/firebase_constants.dart';
import 'package:yappr/core/constants/type_def.dart';
import 'package:yappr/core/providers/auth_provider.dart';
import 'package:yappr/models/message_model.dart';
import 'package:yappr/models/usermodel.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(firestore: ref.watch(firestoreProvider));
});

class ChatRepository {
  final FirebaseFirestore _firestore;
  ChatRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createMessage({
    required Message newMessage,
    required String senderId,
    required String receiverId,
  }) async {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    try {
      final chatRoomDoc = await _chats.doc(chatRoomId).get();

      if (!chatRoomDoc.exists) {
        await _chats.doc(chatRoomId).set({
          'participants': ids,
          'lastMessage': newMessage.message,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        await _chats.doc(chatRoomId).update({
          'lastMessage': newMessage.message,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      await _chats
          .doc(chatRoomId)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? 'An unknown error occurred'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteMessages({
    required String senderId,
    required String receiverId,
    required List<String> messageIds,
  }) async {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    try {
      final batch = _firestore.batch();

      for (String messageId in messageIds) {
        final messageRef =
            _chats.doc(chatRoomId).collection('messages').doc(messageId);

        batch.delete(messageRef);
      }

      await batch.commit();

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? 'An unknown error occurred'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Message>> getMessages(String chatRoomId) {
    try {
      return _chats
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => Message.fromMap(e.data()),
                )
                .toList(),
          );
    } catch (e) {
      return Stream.error(Failure(e.toString()));
    }
  }

  Stream<List<UserModel>> fetchAllUsers() {
    try {
      return _users.snapshots().map(
            (event) => event.docs
                .map(
                  (e) => UserModel.fromMap(e.data() as Map<String, dynamic>),
                )
                .toList(),
          );
    } catch (e) {
      return Stream.error(Failure(e.toString()));
    }
  }

  FutureVoid updateMessage({
    required String messageId,
    required String newMessageContent,
    required String senderId,
    required String receiverId,
  }) async {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    try {
      final messageRef =
          _chats.doc(chatRoomId).collection('messages').doc(messageId);

      final messageDoc = await messageRef.get();

      if (!messageDoc.exists) {
        return left(Failure('Message not found'));
      }

      await messageRef.update({
        'message': newMessageContent,
      });

      await _chats.doc(chatRoomId).update({
        'lastMessage': newMessageContent,
      });

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? 'An unknown error occurred'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _chats =>
      _firestore.collection(FirebaseConstants.chatsCollection);
}
