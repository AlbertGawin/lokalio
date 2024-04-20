import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/core/navbar/bloc/main_page_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/pages/home_page.dart';
import 'package:lokalio/features/notice_list/presentation/pages/my_notices_page.dart';
import 'package:lokalio/features/profile/presentation/pages/my_profile_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: MainPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainPageBloc(),
      child: BlocBuilder<MainPageBloc, MainPageState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: IndexedStack(
                index: state.tabIndex,
                children: bottomNavScreen,
              ),
            ),
            bottomNavigationBar: NavigationBar(
              destinations: bottomNavItems,
              selectedIndex: state.tabIndex,
              onDestinationSelected: (index) => context
                  .read<MainPageBloc>()
                  .add(TabChangeEvent(tabIndex: index)),
            ),
          );
        },
      ),
    );
  }

  static const List<NavigationDestination> bottomNavItems =
      <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      label: 'Start',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_outline),
      selectedIcon: Icon(Icons.favorite),
      label: 'Obserwuję',
    ),
    NavigationDestination(
      icon: Icon(Icons.storefront_outlined),
      selectedIcon: Icon(Icons.storefront_rounded),
      label: 'Sprzedaję',
    ),
    NavigationDestination(
      icon: Icon(Icons.chat_bubble_outline),
      selectedIcon: Icon(Icons.chat_bubble),
      label: 'Czat',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_circle_outlined),
      selectedIcon: Icon(Icons.account_circle),
      label: 'Konto',
    ),
  ];

  static const List<Widget> bottomNavScreen = <Widget>[
    HomePage(),
    Text('Index 1: Category'),
    MyNoticesPage(),
    Text('Index 3: Favourite'),
    MyProfilePage(),
  ];
}
