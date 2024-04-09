import 'package:flutter/material.dart';

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
                onPressed: () {},
                child: const Text('Zaloguj się'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
