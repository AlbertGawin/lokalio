import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/features/profile/data/models/profile.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tProfileModel = ProfileModel.fromJson(
    json: json.decode(fixture(name: 'profile.json')),
  );

  test('should be a subclass of Profile entity', () async {
    expect(tProfileModel, isA<Profile>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON is provided', () async {
      final result = ProfileModel.fromJson(
        json: json.decode(fixture(name: 'profile.json')),
      );

      expect(result, equals(tProfileModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tProfileModel.toJson();

      expect(result, equals(json.decode(fixture(name: 'profile.json'))));
    });
  });
}
