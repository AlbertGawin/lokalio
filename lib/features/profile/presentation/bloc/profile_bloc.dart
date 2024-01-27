import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/core/usecases/usecase.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/profile/domain/usecases/read_my_profile.dart';
import 'package:lokalio/features/profile/domain/usecases/read_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ReadProfile readProfile;
  final ReadMyProfile readMyProfile;

  ProfileBloc({required this.readProfile, required this.readMyProfile})
      : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ReadProfileEvent) {
        emit(Loading());
        await readProfile(Params(profileId: event.profileId)).then((profile) {
          profile.fold(
            (failure) => emit(Error(message: failureMessages[failure.type]!)),
            (profile) => emit(Done(profile: profile)),
          );
        });
      } else if (event is ReadMyProfileEvent) {
        emit(Loading());
        await readMyProfile(NoParams()).then((profile) {
          profile.fold(
            (failure) => emit(Error(message: failureMessages[failure.type]!)),
            (profile) => emit(Done(profile: profile)),
          );
        });
      }
    });
  }
}
