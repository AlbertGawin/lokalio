import 'package:flutter/material.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/read_notice/presentation/widgets/image_list_widget.dart';
import 'package:lokalio/features/read_notice/presentation/widgets/location_info_widget.dart';
import 'package:lokalio/features/read_notice/presentation/widgets/notice_description_widget.dart';
import 'package:lokalio/features/read_notice/presentation/widgets/notice_info_widget.dart';
import 'package:lokalio/features/read_notice/presentation/widgets/user_info_widget.dart';

class NoticeWidget extends StatelessWidget {
  final NoticeDetails noticeDetails;

  const NoticeWidget({super.key, required this.noticeDetails});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (noticeDetails.imagesUrl != null)
                ImageListWidget(imageUrls: noticeDetails.imagesUrl!),
              const SizedBox(height: 16),
              NoticeInfoWidget(
                title: noticeDetails.title,
                cashAmount: noticeDetails.cashAmount,
                peopleAmount: noticeDetails.peopleAmount,
                dateTimeRange: noticeDetails.dateTimeRange,
              ),
              const SizedBox(height: 16),
              NoticeDescriptionWidget(description: noticeDetails.description),
              const SizedBox(height: 16),
              UserInfoWidget(userId: noticeDetails.userId),
              const SizedBox(height: 16),
              LocationInfoWidget(location: noticeDetails.location)
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
