import 'package:equatable/equatable.dart';

class Notice extends Equatable {
  final String id;
  final String title;
  final String userId;

  const Notice({
    required this.id,
    required this.title,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, title, userId];
}
