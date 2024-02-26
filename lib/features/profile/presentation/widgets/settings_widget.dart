import 'package:flutter/material.dart';
import 'package:lokalio/features/profile/presentation/widgets/menu_item_widget.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MenuItemWidget(
              onPressed: () {},
              label: 'Zmień hasło',
            ),
            MenuItemWidget(
              onPressed: () {},
              label: 'Zmień email',
            ),
            MenuItemWidget(
              onPressed: () {},
              label: 'Tryb ciemny',
            ),
            MenuItemWidget(
              onPressed: () {},
              label: 'Usuń konto',
            ),
          ],
        ),
      ),
    );
  }
}
