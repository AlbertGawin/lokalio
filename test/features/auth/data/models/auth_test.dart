import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/auth/data/models/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUser = UserModel.fromJson(
    json: json.decode(fixture(name: 'user.json')),
  );

  group('fromJson', () {
    test('should return a valid model when JSON is provided', () async {
      final result = UserModel.fromJson(
        json: json.decode(fixture(name: 'user.json')),
      );

      expect(result, equals(tUser));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tUser.toJson();

      expect(result, equals(json.decode(fixture(name: 'user.json'))));
    });
  });
}
