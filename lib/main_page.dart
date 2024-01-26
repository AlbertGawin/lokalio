import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lokalio/core/pages/anonymous_page.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/create_notice/presentation/pages/create_notice_page.dart';
import 'package:lokalio/features/notice_list/presentation/pages/favorite_page.dart';
import 'package:lokalio/features/notice_list/presentation/pages/home_page.dart';

class MainPage extends StatefulWidget {
  final bool isAnonymous;

  const MainPage({super.key, required this.isAnonymous});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2 && !widget.isAnonymous) {
      Navigator.of(context).push(
        createRoute(const CreateNoticePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.isAnonymous ? _anonymousWidgetOptions : _widgetOptions,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: _widgetDestinations,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const FavoritePage(),
    const CreateNoticePage(),
    Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Wyloguj się'),
            ),
          ],
        ),
      ),
    ),
  ];

  static final List<Widget> _anonymousWidgetOptions = <Widget>[
    const HomePage(),
    const AnonymousPage(
      title: 'Tutaj znajdziesz ogłoszenia, które obserwujesz.',
    ),
    const AnonymousPage(
      title: 'Tutaj możesz dodawać swoje ogłoszenia.',
    ),
    const AnonymousPage(
      title: 'Tutaj znajdziesz swój profil.',
    ),
  ];

  static final List<Widget> _widgetDestinations = <Widget>[
    const NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      label: 'Ogłoszenia',
    ),
    const NavigationDestination(
      icon: Icon(Icons.favorite_border_outlined),
      selectedIcon: Icon(Icons.favorite),
      label: 'Ulubione',
    ),
    const NavigationDestination(
      icon: Icon(Icons.add),
      selectedIcon: Icon(Icons.add),
      label: 'Dodaj',
    ),
    const NavigationDestination(
      icon: Icon(Icons.account_circle_outlined),
      selectedIcon: Icon(Icons.account_circle),
      label: 'Profil',
    ),
  ];
}
