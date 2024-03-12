import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String id;
  final String receiverId;

  const Chat({
    required this.id,
    required this.receiverId,
  });

  @override
  List<Object?> get props => [id, receiverId];
}
