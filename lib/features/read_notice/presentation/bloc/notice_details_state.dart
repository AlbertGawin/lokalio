part of 'notice_details_bloc.dart';

sealed class NoticeDetailsState extends Equatable {
  const NoticeDetailsState();

  @override
  List<Object> get props => [];
}

final class NoticeDetailsInitial extends NoticeDetailsState {}

final class Loading extends NoticeDetailsState {}

final class Done extends NoticeDetailsState {
  final NoticeDetails noticeDetails;

  const Done({required this.noticeDetails});

  @override
  List<Object> get props => [noticeDetails];
}

final class Error extends NoticeDetailsState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
