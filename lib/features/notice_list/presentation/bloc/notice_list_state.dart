part of 'notice_list_bloc.dart';

enum NoticeListStatus {
  loading,
  success,
  failure,
}

final class NoticeListState extends Equatable {
  final NoticeListStatus status;
  final List<Notice> notices;

  const NoticeListState._({
    required this.status,
    this.notices = const [],
  });

  const NoticeListState.loading() : this._(status: NoticeListStatus.loading);

  const NoticeListState.done({required List<Notice> notices})
      : this._(status: NoticeListStatus.success, notices: notices);

  const NoticeListState.error() : this._(status: NoticeListStatus.failure);

  @override
  List<Object> get props => [status, notices];
}
