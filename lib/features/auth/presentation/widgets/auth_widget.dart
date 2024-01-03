import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Center(child: Text('You are logged in'));
        } else {
          return const Center(child: Text('You are not logged in'));
        }
      },
    );
  }
}
