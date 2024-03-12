import 'package:lokalio/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.senderId,
    required super.receiverId,
    required super.message,
    required super.timestamp,
  });

  factory MessageModel.fromMessage({required Message message}) {
    return MessageModel(
      senderId: message.senderId,
      receiverId: message.receiverId,
      message: message.message,
      timestamp: message.timestamp,
    );
  }

  factory MessageModel.fromJson({required Map<String, dynamic> json}) {
    return MessageModel(
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  MessageModel copyWith({
    String? senderId,
    String? receiverId,
    String? message,
    String? timestamp,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
