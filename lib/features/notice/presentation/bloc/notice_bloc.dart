import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/features/notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice/domain/repositories/notice_repository.dart';

part 'notice_event.dart';
part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepository _repository;

  NoticeBloc({required NoticeRepository repository})
      : _repository = repository,
        super(const NoticeState.loading()) {
    on<NoticeEvent>((event, emit) async {
      if (event is GetNoticeDetailsEvent) {
        await _repository.readNotice(noticeId: event.noticeId).then((chooser) {
          chooser.fold(
            (failure) => emit(const NoticeState.failure()),
            (notice) => emit(NoticeState.success(notice: notice)),
          );
        });
      }
    });
  }
}
