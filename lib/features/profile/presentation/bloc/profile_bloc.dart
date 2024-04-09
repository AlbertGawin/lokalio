import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/profile/domain/usecases/read_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ReadProfile readProfile;

  ProfileBloc({required this.readProfile}) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ReadProfileEvent) {
        emit(Loading());
        await readProfile(Params(userId: event.userId)).then((profile) {
          emit(Done(profile: profile));
        });
      }
    });
  }
}
