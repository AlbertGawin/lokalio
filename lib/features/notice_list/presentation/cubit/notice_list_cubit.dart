import 'package:bloc/bloc.dart';
import 'package:lokalio/features/notice_list/domain/domain.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';

class NoticeListCubit extends Cubit<NoticeListState> {
  final NoticeListRepository _noticeListRepository;

  NoticeListCubit(this._noticeListRepository)
      : super(const NoticeListState.loading());

  Future<void> getAllNotices() async {
    emit(const NoticeListState.loading());
    try {
      final notices = await _noticeListRepository.getAllNotices();
      emit(NoticeListState.done(notices: notices));
    } catch (e) {
      emit(const NoticeListState.error());
    }
  }

  Future<void> getUserNotices({required String userId}) async {
    emit(const NoticeListState.loading());
    try {
      final notices =
          await _noticeListRepository.getUserNotices(userId: userId);
      emit(NoticeListState.done(notices: notices));
    } catch (e) {
      emit(const NoticeListState.error());
    }
  }
}
