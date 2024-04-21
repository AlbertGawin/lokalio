import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/presentation/cubit/profile_data_addition_cubit.dart';
import 'package:lokalio/features/auth/presentation/widgets/profile_data_addition_form.dart';

class ProfileDataAdditionPage extends StatelessWidget {
  const ProfileDataAdditionPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: ProfileDataAdditionPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uzupełnij dane profilu')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<ProfileDataAdditionCubit>(
          create: (_) =>
              ProfileDataAdditionCubit(context.read<AuthRepository>()),
          child: const ProfileDataAdditionForm(),
        ),
      ),
    );
  }
}
