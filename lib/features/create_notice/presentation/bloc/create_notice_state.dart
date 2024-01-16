part of 'create_notice_bloc.dart';

sealed class CreateNoticeState extends Equatable {
  const CreateNoticeState();

  @override
  List<Object> get props => [];
}

final class CreateNoticeInitial extends CreateNoticeState {}

final class Loading extends CreateNoticeState {}

final class Done extends CreateNoticeState {}

final class Error extends CreateNoticeState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
