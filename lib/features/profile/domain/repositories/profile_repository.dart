import 'package:lokalio/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> readProfile({required String userId});
}
