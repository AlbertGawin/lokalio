import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/profile/domain/entities/profile.dart';
import 'package:lokalio/features/notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice/domain/repositories/notice_repository.dart';
import 'package:lokalio/features/notice/presentation/bloc/notice_bloc.dart';
import 'package:lokalio/features/notice/presentation/widgets/image_list_widget.dart';
import 'package:lokalio/features/notice/presentation/widgets/location_info_widget.dart';
import 'package:lokalio/features/notice/presentation/widgets/notice_description_widget.dart';
import 'package:lokalio/features/notice/presentation/widgets/notice_info_widget.dart';
import 'package:lokalio/features/notice/presentation/widgets/profile_info_widget.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';
import 'package:lokalio/features/profile/presentation/bloc/profile_bloc.dart';

import 'package:lokalio/injection_container.dart';

class NoticeWidget extends StatefulWidget {
  final String noticeId;

  const NoticeWidget({super.key, required this.noticeId});

  @override
  State<NoticeWidget> createState() => _NoticeWidgetState();
}

class _NoticeWidgetState extends State<NoticeWidget> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<Color> _appBarColor = ValueNotifier(Colors.transparent);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NoticeBloc(repository: sl<NoticeRepository>())
            ..add(GetNoticeDetailsEvent(noticeId: widget.noticeId)),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(repository: sl<ProfileRepository>()),
        ),
      ],
      child: BlocBuilder<NoticeBloc, NoticeState>(
        builder: (context, noticeState) {
          switch (noticeState.status) {
            case NoticeStatus.success:
              return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) {
                context.read<ProfileBloc>().add(
                    GetProfileEvent(userId: noticeState.noticeDetails.userId));

                switch (profileState.status) {
                  case ProfileStatus.success:
                    return _buildNoticeWidget(
                      noticeDetails: noticeState.noticeDetails,
                      profile: profileState.profile,
                    );
                  case ProfileStatus.loading:
                    return _buildLoadingWidget();
                  case ProfileStatus.failure:
                    return _buildFailureWidget(message: 'Failed to load user');
                }
              });
            case NoticeStatus.loading:
              return _buildLoadingWidget();
            case NoticeStatus.failure:
              return _buildFailureWidget(message: 'Failed to load notice');
          }
        },
      ),
    );
  }

  Widget _buildNoticeWidget({
    required NoticeDetails noticeDetails,
    required Profile profile,
  }) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _appBarColor,
                    builder: (context, Color color, _) {
                      return ImageListWidget(
                        imageUrls: noticeDetails.imagesUrl,
                        isWhite: color == Colors.white,
                      );
                    },
                  ),
                  NoticeInfoWidget(
                    title: noticeDetails.title,
                    moneyAmount: noticeDetails.moneyAmount,
                    peopleAmount: noticeDetails.peopleAmount,
                  ),
                  const SizedBox(height: 8),
                  NoticeDescriptionWidget(
                      description: noticeDetails.description),
                  const SizedBox(height: 8),
                  ProfileInfoWidget(profile: profile),
                  const SizedBox(height: 8),
                  LocationInfoWidget(location: noticeDetails.location),
                  const SizedBox(height: 16),
                ],
              ),
              _buildFavoriteButton(),
            ],
          ),
        ),
        _buildAppBar(),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Stack(
      children: [
        const Center(child: CircularProgressIndicator()),
        _buildAppBar(),
      ],
    );
  }

  Widget _buildFailureWidget({required String message}) {
    return Stack(
      children: [
        Center(child: Text(message)),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Colors.black,
            shadowColor: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return ValueListenableBuilder(
      valueListenable: _appBarColor,
      builder: (context, Color color, _) {
        if (color == Colors.white) {
          return const SizedBox.shrink();
        }
        return Positioned(
          top: 225,
          right: 6,
          child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: const Icon(Icons.favorite_outline, size: 24)),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return ValueListenableBuilder(
      valueListenable: _appBarColor,
      builder: (context, Color color, _) {
        final isWhite = color == Colors.white;
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            actions: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.share_outlined),
              ),
              if (color == Colors.white)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.favorite_outline),
                ),
            ],
            backgroundColor: color,
            foregroundColor: isWhite ? Colors.black : Colors.white,
            shadowColor: isWhite ? Colors.grey.shade100 : null,
            elevation: isWhite ? 1.0 : 0.0,
            scrolledUnderElevation: isWhite ? 1.0 : 0.0,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _appBarColor.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 180) {
      _appBarColor.value = Colors.white;
    } else {
      _appBarColor.value = Colors.transparent;
    }
  }
}
