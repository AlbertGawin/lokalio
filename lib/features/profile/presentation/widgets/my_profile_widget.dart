import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/pages/pages.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/profile/presentation/widgets/menu_item_widget.dart';
import 'package:lokalio/features/profile/presentation/widgets/profile_info_widget.dart';
import 'package:lokalio/features/profile/presentation/widgets/settings_widget.dart';
import 'package:lokalio/features/profile/presentation/widgets/wallet_widget.dart';

class MyProfileWidget extends StatelessWidget {
  final Profile profile;

  const MyProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProfileInfoWidget(profile: profile),
          const SizedBox(height: 16),
          MenuItemWidget(
            onPressed: () {
              Navigator.of(context).push(createRoute(UserPage(
                userId: profile.id,
              )));
            },
            label: 'Moje ogłoszenia',
          ),
          MenuItemWidget(
            onPressed: () {
              Navigator.of(context).push(createRoute(const WalletWidget()));
            },
            label: 'Portfel',
          ),
          MenuItemWidget(
            onPressed: () {
              Navigator.of(context).push(createRoute(const SettingsWidget()));
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
  }
}
