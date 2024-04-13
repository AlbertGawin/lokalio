import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc({required ProfileRepository repository})
      : _repository = repository,
        super(const ProfileState.loading()) {
    on<ProfileEvent>((event, emit) async {
      if (event is GetProfileEvent) {
        await _repository.getProfile(userId: event.userId).then((chooser) {
          chooser.fold(
            (failure) => emit(const ProfileState.failure()),
            (profile) => emit(ProfileState.success(profile: profile)),
          );
        });
      }
    });
  }
}
