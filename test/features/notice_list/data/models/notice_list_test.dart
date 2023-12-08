import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/notice_list/data/models/notice.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

void main() {
  const tNoticeListModel = [NoticeModel(id: '78asb6', title: 'dupa romana')];

  test('should be a subclass of List<Notice> entity', () async {
    expect(tNoticeListModel, isA<List<Notice>>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () async {
      for (NoticeModel matcher in tNoticeListModel) {
        final actual = NoticeModel.fromJson(json: const {
          'id': '78asb6',
          'title': 'dupa romana',
        });

        expect(actual, matcher);
      }
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      for (NoticeModel tNoticeModel in tNoticeListModel) {
        final actual = tNoticeModel.toJson();
        final matcher = {
          'id': '78asb6',
          'title': 'dupa romana',
        };

        expect(actual, matcher);
      }
    });
  });
}
