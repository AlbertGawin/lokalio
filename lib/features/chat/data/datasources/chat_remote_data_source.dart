import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokalio/features/chat/data/models/chat.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getAllChats();
  Future<void> sendMessage({
    required String message,
    required String receiverId,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  ChatRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
  Future<List<ChatModel>> getAllChats() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(message: 'User not found', code: '');
    }

    final query = await firebaseFirestore
        .collection('chat')
        .where('receiverId', isEqualTo: user.uid)
        .get();

    final chats = query.docs.map((snapshot) {
      return ChatModel.fromJson(json: snapshot.data());
    }).toList();

    return chats;
  }

  @override
  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(message: 'User not found', code: '');
    }

    final chat = ChatModel(
      receiverId: receiverId,
      id: '',
    );

    await firebaseFirestore.collection('chat').add(chat.toJson());
  }
}
