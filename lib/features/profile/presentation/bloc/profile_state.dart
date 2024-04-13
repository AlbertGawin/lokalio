part of 'profile_bloc.dart';

enum ProfileStatus { loading, success, failure }

final class ProfileState extends Equatable {
  final ProfileStatus status;
  final Profile profile;

  const ProfileState._({
    required this.status,
    this.profile = Profile.empty,
  });

  const ProfileState.loading() : this._(status: ProfileStatus.loading);

  const ProfileState.success({required Profile profile})
      : this._(status: ProfileStatus.success, profile: profile);

  const ProfileState.failure() : this._(status: ProfileStatus.failure);

  @override
  List<Object> get props => [status, profile];
}
