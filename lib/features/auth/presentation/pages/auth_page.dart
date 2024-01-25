import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/features/auth/presentation/widgets/auth_widget.dart';
import 'package:lokalio/features/auth/presentation/widgets/set_profile_info_widget.dart';

import 'package:lokalio/injection_container.dart';
import 'package:lokalio/main_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildBody(context));
  }

  BlocProvider<AuthBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return const Center(child: Text('Auth Initial'));
          } else if (state is Loading || state is Done || state is Error) {
            return _streamLogic();
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }

  StreamBuilder<User?> _streamLogic() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is User) {
            final user = snapshot.data as User;
            if (user.displayName == null ||
                user.displayName!.isEmpty ||
                user.phoneNumber == null ||
                user.phoneNumber!.isEmpty) {
              return SetProfileInfoWidget(
                name: user.displayName,
                phone: user.phoneNumber,
              );
            } else {
              return const MainPage();
            }
          } else {
            return const AuthWidget();
          }
        } else {
          return const AuthWidget();
        }
      },
    );
  }
}
