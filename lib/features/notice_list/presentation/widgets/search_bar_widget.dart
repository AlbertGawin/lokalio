import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SearchBar(
        leading: Row(children: [SizedBox(width: 8), Icon(Icons.menu)]),
        trailing: [Icon(Icons.search), SizedBox(width: 8)],
      ),
    );
  }
}
