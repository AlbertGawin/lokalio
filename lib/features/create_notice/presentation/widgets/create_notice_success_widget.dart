import 'package:flutter/material.dart';

class CreateNoticeSuccessWidget extends StatelessWidget {
  const CreateNoticeSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Dodano ogłosznienie!"),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Wróć"),
          ),
        ],
      ),
    );
  }
}
