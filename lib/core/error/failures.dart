import 'package:equatable/equatable.dart';

enum FailureType {
  serverFailure,
  cacheFailure,
  firebaseFailure,
  noDataFailure,
  noConnectionFailure,
  userNotFoundFailure,
  wrongPasswordFailure,
  emailAlreadyInUseFailure,
}

const failureMessages = {
  FailureType.serverFailure: 'Server Failure',
  FailureType.cacheFailure: 'Cache Failure',
  FailureType.firebaseFailure: 'Firebase Failure',
  FailureType.noDataFailure: 'No data found.',
  FailureType.noConnectionFailure: 'No connection.',
  FailureType.userNotFoundFailure: 'User not found.',
  FailureType.wrongPasswordFailure: 'Wrong password.',
  FailureType.emailAlreadyInUseFailure: 'Email already in use.',
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

class FirebaseFailure extends Failure {
  @override
  final String message;

  const FirebaseFailure({required this.message})
      : super(type: FailureType.firebaseFailure);
}

class NoDataFailure extends Failure {
  const NoDataFailure() : super(type: FailureType.noDataFailure);
}

class NoConnectionFailure extends Failure {
  const NoConnectionFailure() : super(type: FailureType.noConnectionFailure);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super(type: FailureType.userNotFoundFailure);
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure() : super(type: FailureType.wrongPasswordFailure);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure()
      : super(type: FailureType.emailAlreadyInUseFailure);
}
