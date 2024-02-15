import 'package:flutter/material.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';

class ProfileInfoWidget extends StatelessWidget {
  final Profile profile;

  const ProfileInfoWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
