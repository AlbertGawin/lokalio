import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';
import 'package:lokalio/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:lokalio/features/profile/presentation/widgets/my_profile_widget.dart';
import 'package:lokalio/injection_container.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.select((AuthBloc bloc) => bloc.state.user.id);

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocProvider(
        create: (context) => ProfileBloc(repository: sl<ProfileRepository>())
          ..add(GetProfileEvent(userId: userId)),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            switch (state.status) {
              case ProfileStatus.success:
                return MyProfileWidget(profile: state.profile);
              case ProfileStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ProfileStatus.failure:
                return const Center(child: Text('Failed to load profile'));
            }
          },
        ),
      ),
    );
  }
}
