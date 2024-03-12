import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:lokalio/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements ChatRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ChatRepositoryImpl repository;

  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = ChatRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllChats', () {});
  group('sendMessage', () {});
}
