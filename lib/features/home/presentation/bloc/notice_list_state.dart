part of 'notice_list_bloc.dart';

sealed class NoticeListState extends Equatable {
  const NoticeListState();

  @override
  List<Object> get props => [];
}

final class Empty extends NoticeListState {}

final class Loading extends NoticeListState {}

final class Done extends NoticeListState {
  final List<Notice> noticeList;

  const Done({required this.noticeList});

  @override
  List<Object> get props => [noticeList];
}

final class Error extends NoticeListState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
