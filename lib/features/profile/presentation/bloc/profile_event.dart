part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class GetProfileEvent extends ProfileEvent {
  final String userId;

  const GetProfileEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
