import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String city;
  final String createdAt;
  final String? imageUrl;

  const Profile({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.createdAt,
    this.imageUrl,
  });

  static const empty = Profile(
    id: '',
    username: '',
    email: '',
    phoneNumber: '',
    city: '',
    createdAt: '',
  );

  bool get isEmpty => this == Profile.empty;

  bool get isNotEmpty => this != Profile.empty;

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        phoneNumber,
        city,
        createdAt,
        imageUrl,
      ];
}
