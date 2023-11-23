import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokalio',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.green.shade800,
      ),
      home: const Scaffold(
        body: Text('Lokalio'),
      ),
    );
  }
}
