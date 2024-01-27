part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class Loading extends ProfileState {}

final class Done extends ProfileState {
  final Profile profile;

  const Done({required this.profile});

  @override
  List<Object> get props => [profile];
}

final class Error extends ProfileState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
