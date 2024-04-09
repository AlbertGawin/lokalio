import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';

class GetAllNotices implements UseCase<List<Notice>, NoParams> {
  final NoticeListRepository noticeListRepository;

  const GetAllNotices({required this.noticeListRepository});

  @override
  Future<List<Notice>> call(NoParams params) async {
    return await noticeListRepository.getAllNotices();
  }
}
