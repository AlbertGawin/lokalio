import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:lokalio/features/auth/presentation/pages/auth_page.dart';
import 'package:lokalio/features/notice_list/presentation/pages/home_page.dart';
import 'firebase_options.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    Center(
      child: ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        child: const Text('Wyloguj się'),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokalio',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blueGrey,
      ),
      home: const Scaffold(
        body: AuthPage(),
        // IndexedStack(
        //   index: _selectedIndex,
        //   children: _widgetOptions,
        // ),
        // bottomNavigationBar: NavigationBar(
        //   destinations: const <Widget>[
        //     NavigationDestination(
        //       icon: Icon(Icons.search_outlined),
        //       selectedIcon: Icon(Icons.search),
        //       label: 'Ogłoszenia',
        //     ),
        //     NavigationDestination(
        //       icon: Icon(Icons.account_circle_outlined),
        //       selectedIcon: Icon(Icons.account_circle),
        //       label: 'Profil',
        //     ),
        //   ],
        //   selectedIndex: _selectedIndex,
        //   onDestinationSelected: _onItemTapped,
        // ),
      ),
    );
  }
}
