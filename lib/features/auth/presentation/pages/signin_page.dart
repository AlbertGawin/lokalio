import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/presentation/cubit/signin_cubit.dart';
import 'package:lokalio/features/auth/presentation/widgets/signin_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: SignInPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<SignInCubit>.value(
          value: SignInCubit(context.read<AuthRepository>()),
          child: const SignInForm(),
        ),
      ),
    );
  }
}
