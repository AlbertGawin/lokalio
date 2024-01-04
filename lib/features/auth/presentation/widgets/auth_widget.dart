import 'package:flutter/material.dart';
import 'package:lokalio/features/auth/presentation/widgets/sign_in_widget.dart';
import 'package:lokalio/features/auth/presentation/widgets/sign_up_widget.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool _isSignIn = true;

  void _toggleAuthMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isSignIn) SignInWidget(),
          if (!_isSignIn) SignUpWidget(),
          TextButton(
            onPressed: _toggleAuthMode,
            child: Text(_isSignIn ? 'Switch to Sign Up' : 'Switch to Sign In'),
          ),
        ],
      ),
    );
  }
}
