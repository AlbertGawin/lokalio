import 'package:flutter/foundation.dart';
import 'package:lokalio/core/cache/cache.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';

abstract class AuthLocalDataSource {
  Profile get currentProfile;
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final CacheClient cache;

  const AuthLocalDataSourceImpl({required this.cache});

  @visibleForTesting
  static const profileCacheKey = '__profile_cache_key__';

  @override
  Profile get currentProfile {
    return cache.read<Profile>(key: profileCacheKey) ?? Profile.empty;
  }
}
