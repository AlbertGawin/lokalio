import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String city;
  final Timestamp createdAt;
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
