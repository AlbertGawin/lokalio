import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const MenuItemWidget({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 4,
      title: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      ),
    );
  }
}
