import 'package:flutter/material.dart';

class NoticeInfoWidget extends StatelessWidget {
  final String title;
  final int moneyAmount;
  final int peopleAmount;

  const NoticeInfoWidget({
    super.key,
    required this.title,
    required this.moneyAmount,
    required this.peopleAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '$moneyAmount',
                    style: const TextStyle(fontSize: 30),
                  ),
                  const TextSpan(
                    text: ' zł',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.handshake),
              label: Text('Zgłoś się'.toUpperCase()),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text('Napisz'.toUpperCase()),
            )
          ],
        ),
      ),
    );
  }
}
