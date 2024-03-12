import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String senderId;
  final String receiverId;
  final String message;
  final String timestamp;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [senderId, receiverId, message, timestamp];
}
