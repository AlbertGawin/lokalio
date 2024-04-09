
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/features/notice_list/domain/domain.dart';

part 'notice_list_event.dart';
part 'notice_list_state.dart';

class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final NoticeListRepository _repository;

  NoticeListBloc({required NoticeListRepository repository})
      : _repository = repository,
        super(const NoticeListState.loading()) {
    on<NoticeListEvent>((event, emit) async {
      if (event is GetAllNoticesEvent) {
        await _repository.getAllNotices().then((notices) {
          emit(NoticeListState.done(notices: notices));
        });
      } else if (event is GetUserNoticesEvent) {
        await _repository.getUserNotices(userId: event.userId).then((notices) {
          emit(NoticeListState.done(notices: notices));
        });
      }
    });
  }
}
