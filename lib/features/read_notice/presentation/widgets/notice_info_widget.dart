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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$moneyAmount',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                TextSpan(
                  text: ' zł',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildIconRow(
            icon: Icons.groups,
            text: '$peopleAmount',
            context: context,
          ),
        ],
      ),
    );
  }

  Row _buildIconRow({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
