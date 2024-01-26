import 'package:flutter/material.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/auth/presentation/pages/auth_page.dart';

class AnonymousPage extends StatelessWidget {
  final String title;

  const AnonymousPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(title),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(const AuthPage(signInClicked: true)),
                  );
                },
                child: const Text('Zaloguj się'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
