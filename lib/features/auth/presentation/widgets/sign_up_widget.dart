import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        ),
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        ),
        TextFormField(
          controller: confirmPasswordController,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(SignUpEvent(
                  email: emailController.text,
                  password: passwordController.text,
                ));
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
