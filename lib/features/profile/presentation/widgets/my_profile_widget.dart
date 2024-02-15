import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/pages/my_notices_page.dart';

class MyProfileWidget extends StatelessWidget {
  const MyProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(createRoute(const MyNoticesPage()));
              },
              child: const Text('Moje ogłoszenia'),
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
    );
  }
}
