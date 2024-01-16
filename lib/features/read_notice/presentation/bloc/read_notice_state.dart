part of 'read_notice_bloc.dart';

sealed class ReadNoticeState extends Equatable {
  const ReadNoticeState();

  @override
  List<Object> get props => [];
}

final class ReadNoticeInitial extends ReadNoticeState {}

final class Loading extends ReadNoticeState {}

final class Done extends ReadNoticeState {
  final NoticeDetails noticeDetails;

  const Done({required this.noticeDetails});

  @override
  List<Object> get props => [noticeDetails];
}

final class Error extends ReadNoticeState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
