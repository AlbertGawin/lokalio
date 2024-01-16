import 'package:bloc/bloc.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/usecases/get_all_notices.dart';
import 'package:lokalio/features/notice_list/domain/usecases/get_user_notices.dart';

part 'notice_list_event.dart';
part 'notice_list_state.dart';

class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final GetAllNotices getAllNotices;
  final GetUserNotices getUserNotices;

  NoticeListBloc({
    required this.getAllNotices,
    required this.getUserNotices,
  }) : super(NoticeListInitial()) {
    on<NoticeListEvent>((event, emit) async {
      if (event is GetAllNoticesEvent) {
        emit(Loading());
        await getAllNotices(NoParams()).then((notices) {
          notices.fold(
            (failure) => emit(Error(message: failureMessages[failure.type]!)),
            (noticeList) => emit(Done(noticeList: noticeList)),
          );
        });
      } else if (event is GetUserNoticesEvent) {
        emit(Loading());
        await getUserNotices(Params(userId: event.userId)).then((notices) {
          notices.fold(
            (failure) => emit(Error(message: failureMessages[failure.type]!)),
            (noticeList) => emit(Done(noticeList: noticeList)),
          );
        });
      }
    });
  }
}
