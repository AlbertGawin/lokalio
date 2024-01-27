part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ReadProfileEvent extends ProfileEvent {
  final String profileId;

  const ReadProfileEvent({required this.profileId});

  @override
  List<Object> get props => [profileId];
}

final class ReadMyProfileEvent extends ProfileEvent {
  const ReadMyProfileEvent();
}
