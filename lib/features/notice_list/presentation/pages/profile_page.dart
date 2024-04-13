import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_list_widget.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/injection_container.dart';

class ProfilePage extends StatelessWidget {
  final Profile profile;

  const ProfilePage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (_) => NoticeListBloc(repository: sl<NoticeListRepository>())
          ..add(GetUserNoticesEvent(userId: profile.id)),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.username,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            profile.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            profile.phoneNumber,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 35.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(profile.imageUrl ??
                            'https://firebasestorage.googleapis.com/v0/b/lokalio-add0f.appspot.com/o/avatar.png?alt=media&token=43f9f5ed-8c31-4ad1-a3fd-fc734ebbed68'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_outline),
                    label: const Text('Obserwuj'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: NoticeListWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
