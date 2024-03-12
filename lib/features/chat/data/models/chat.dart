import 'package:lokalio/features/chat/domain/entities/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.receiverId,
  });

  factory ChatModel.fromChat({required Chat chat}) {
    return ChatModel(
      id: chat.id,
      receiverId: chat.receiverId,
    );
  }

  factory ChatModel.fromJson({required Map<String, dynamic> json}) {
    return ChatModel(
      id: json['id'] as String,
      receiverId: json['receiverId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiverId': receiverId,
    };
  }

  ChatModel copyWith({
    String? id,
    String? receiverId,
  }) {
    return ChatModel(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
    );
  }
}
