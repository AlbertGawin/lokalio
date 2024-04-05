part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ReadProfileEvent extends ProfileEvent {
  final String userId;

  const ReadProfileEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

final class ReadMyProfileEvent extends ProfileEvent {
  const ReadMyProfileEvent();
}
