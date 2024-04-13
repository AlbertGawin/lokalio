import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';

part 'notice_list_event.dart';
part 'notice_list_state.dart';

class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final NoticeListRepository _repository;

  NoticeListBloc({required NoticeListRepository repository})
      : _repository = repository,
        super(const NoticeListState.loading()) {
    on<NoticeListEvent>((event, emit) async {
      if (event is GetAllNoticesEvent) {
        await _repository.getAllNotices().then((chooser) {
          chooser.fold(
            (failure) => emit(const NoticeListState.failure()),
            (notices) => emit(NoticeListState.success(notices: notices)),
          );
        });
      } else if (event is GetUserNoticesEvent) {
        await _repository.getUserNotices(userId: event.userId).then((chooser) {
          chooser.fold(
            (failure) => emit(const NoticeListState.failure()),
            (notices) => emit(NoticeListState.success(notices: notices)),
          );
        });
      }
    });
  }
}
