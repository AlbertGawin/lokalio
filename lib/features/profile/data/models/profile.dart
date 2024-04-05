import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.city,
    required super.createdAt,
    super.imageUrl,
  });

  factory ProfileModel.fromJson({required Map<String, dynamic> json}) {
    return ProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      city: json['city'] as String,
      createdAt: json['createdAt'] as Timestamp,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
    };
  }
}
