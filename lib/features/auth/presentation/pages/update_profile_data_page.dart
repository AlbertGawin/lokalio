import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/injection_container.dart';

class UpdateProfileDataPage extends StatelessWidget {
  const UpdateProfileDataPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: UpdateProfileDataPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(repository: sl<AuthRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update Profile Data'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const SignOutEvent());
                },
                child: const Text('Wyloguj się'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
