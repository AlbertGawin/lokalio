import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/features/notice/presentation/widgets/user_info_widget.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';
import 'package:lokalio/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:lokalio/features/profile/presentation/widgets/menu_item_widget.dart';
import 'package:lokalio/features/profile/presentation/widgets/settings_widget.dart';
import 'package:lokalio/features/profile/presentation/widgets/wallet_widget.dart';
import 'package:lokalio/injection_container.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.select((AuthBloc bloc) => bloc.state.profile.id);

    return BlocProvider(
      create: (context) => ProfileBloc(repository: sl<ProfileRepository>())
        ..add(GetProfileEvent(userId: userId)),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (state.status != ProfileStatus.failure)
                    ProfileInfoWidget(profile: state.profile),
                  const SizedBox(height: 16),
                  MenuItemWidget(
                    onPressed: () {
                      Navigator.of(context)
                          .push(createRoute(const WalletWidget()));
                    },
                    label: 'Portfel',
                  ),
                  MenuItemWidget(
                    onPressed: () {
                      Navigator.of(context)
                          .push(createRoute(const SettingsWidget()));
                    },
                    label: 'Ustawienia',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const SignOutEvent());
                    },
                    child: const Text('Wyloguj się'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
