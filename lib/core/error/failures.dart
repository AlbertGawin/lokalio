import 'package:equatable/equatable.dart';

enum FailureType {
  serverFailure,
  cacheFailure,
  noDataFailure,
  noConnectionFailure
}

const failureMessages = {
  FailureType.serverFailure: 'Server Failure',
  FailureType.cacheFailure: 'Cache Failure',
  FailureType.noDataFailure: 'No data found.',
  FailureType.noConnectionFailure: 'No connection.',
};

abstract class Failure extends Equatable {
  final List properties;
  final FailureType type;

  const Failure({this.properties = const <dynamic>[], required this.type});

  String get message => failureMessages[type] ?? 'Unexpected error';

  @override
  List<Object?> get props => [properties, type];
}

class ServerFailure extends Failure {
  const ServerFailure() : super(type: FailureType.serverFailure);
}

class CacheFailure extends Failure {
  const CacheFailure() : super(type: FailureType.cacheFailure);
}

class NoDataFailure extends Failure {
  const NoDataFailure() : super(type: FailureType.noDataFailure);
}

class NoConnectionFailure extends Failure {
  const NoConnectionFailure() : super(type: FailureType.noConnectionFailure);
}
