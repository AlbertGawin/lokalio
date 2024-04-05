import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void networkInfoTests() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(connectivity: mockConnectivity);
  });

  group('isConnected', () {
    test('should forward the call to InternetConnectionChecker.hasConnection',
        () async {
      final tHasConnectionFuture = Future.value(true);
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = networkInfoImpl.isConnected;

      verify(() => mockConnectivity.checkConnectivity());
      expect(result, tHasConnectionFuture);
    });
  });
}
