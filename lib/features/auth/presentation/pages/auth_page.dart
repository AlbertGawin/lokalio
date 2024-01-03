import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/features/auth/presentation/widgets/auth_widget.dart';

import 'package:lokalio/injection_container.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<AuthBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<AuthBloc>();

        bloc.add(const SignInEvent(email: '', password: ''));
        bloc.add(const SignUpEvent(email: '', password: ''));
        bloc.add(const SignOutEvent());

        return bloc;
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return const Center(child: Text('Press the button below to load'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Done) {
            return const AuthWidget();
          } else if (state is Error) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
