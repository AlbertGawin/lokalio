import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/auth/domain/entities/user.dart';
import 'package:lokalio/features/notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice/domain/repositories/notice_repository.dart';
import 'package:lokalio/features/notice/presentation/bloc/notice_bloc.dart';
import 'package:lokalio/features/notice/presentation/widgets/image_list_widget.dart';
import 'package:lokalio/features/notice/presentation/widgets/location_info_widget.dart';
import 'package:lokalio/features/notice/presentation/widgets/notice_description_widget.dart';
import 'package:lokalio/features/notice/presentation/widgets/notice_info_widget.dart';
import 'package:lokalio/features/notice/presentation/widgets/user_info_widget.dart';

import 'package:lokalio/injection_container.dart';

class NoticeWidget extends StatelessWidget {
  final String noticeId;

  const NoticeWidget({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoticeBloc(repository: sl<NoticeRepository>())
        ..add(ReadNoticeDetailsEvent(noticeId: noticeId)),
      child: BlocBuilder<NoticeBloc, NoticeState>(
        builder: (context, state) {
          switch (state.status) {
            case NoticeStatus.success:
              return _buildNoticeWidget(noticeDetails: state.noticeDetails);
            case NoticeStatus.loading:
              return _buildLoadingWidget();
            case NoticeStatus.failure:
              return _buildFailureWidget();
          }
        },
      ),
    );
  }

  Widget _buildNoticeWidget({required NoticeDetails noticeDetails}) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageListWidget(imageUrls: noticeDetails.imagesUrl),
              NoticeInfoWidget(
                title: noticeDetails.title,
                moneyAmount: noticeDetails.moneyAmount,
                peopleAmount: noticeDetails.peopleAmount,
              ),
              const SizedBox(height: 8),
              NoticeDescriptionWidget(description: noticeDetails.description),
              const SizedBox(height: 8),
              const UserInfoWidget(user: User.empty),
              const SizedBox(height: 8),
              LocationInfoWidget(location: noticeDetails.location),
              const SizedBox(height: 16),
            ],
          ),
        ),
        _buildAppBar(Colors.white),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Stack(
      children: [
        const Center(child: CircularProgressIndicator()),
        _buildAppBar(Colors.black),
      ],
    );
  }

  Widget _buildFailureWidget() {
    return Stack(
      children: [
        const Center(child: Text('Failed to load notice')),
        _buildAppBar(Colors.black),
      ],
    );
  }

  Widget _buildAppBar(Color color) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: color,
        elevation: 0,
      ),
    );
  }
}
