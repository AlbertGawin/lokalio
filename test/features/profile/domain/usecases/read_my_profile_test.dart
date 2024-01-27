import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';
import 'package:lokalio/features/profile/domain/usecases/read_my_profile.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockProfileRepository;
  late ReadMyProfile usecase;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = ReadMyProfile(repository: mockProfileRepository);
  });

  const tProfileId = '1';
  const Profile tProfile = Profile(
    id: tProfileId,
    name: 'Albert',
    email: 'albertg952@gmail.com',
    phoneNumber: '+48881657238',
  );

  test('should get NoticeDetails from the repository', () async {
    when(() => mockProfileRepository.readMyProfile())
        .thenAnswer((_) async => const Right(tProfile));

    final result = await usecase(NoParams());

    expect(result, const Right(tProfile));
    verify(() => mockProfileRepository.readMyProfile());
    verifyNoMoreInteractions(mockProfileRepository);
  });
}
