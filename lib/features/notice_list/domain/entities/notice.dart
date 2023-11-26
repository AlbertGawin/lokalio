import 'package:equatable/equatable.dart';

class Notice extends Equatable {
  final String id;
  final String title;

  const Notice({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}
