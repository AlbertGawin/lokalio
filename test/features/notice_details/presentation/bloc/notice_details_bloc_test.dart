import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/notice_details/domain/usecases/get_notice_details.dart';
import 'package:lokalio/features/notice_details/presentation/bloc/notice_details_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNoticeDetails extends Mock implements GetNoticeDetails {}

void main() {
  late NoticeDetailsBloc bloc;
  late MockGetNoticeDetails mockGetNoticeDetails;

  setUp(() {
    mockGetNoticeDetails = MockGetNoticeDetails();

    bloc = NoticeDetailsBloc(getNoticeDetails: mockGetNoticeDetails);
  });

  setUpAll(() {
    registerFallbackValue(const Params(noticeId: '1'));
    registerFallbackValue(NoParams());
  });

  test('initialState should be NoticeListInitial', () {
    expect(bloc.state, equals(NoticeDetailsInitial()));
  });
}
