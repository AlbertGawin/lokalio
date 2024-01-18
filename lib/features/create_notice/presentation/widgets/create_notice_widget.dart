import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/amounts_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/category_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/date_time_range_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/location_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/title_desc_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/image_input_widget.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

class CreateNoticeWidget extends StatelessWidget {
  const CreateNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String title = '';
    String description = '';
    int category = 0;
    int cashAmount = 0;
    int peopleAmount = 0;
    Position location = Position.fromMap(const {
      'latitude': 0.0,
      'longitude': 0.0,
      'timestamp': 0.0,
    });
    DateTimeRange dateTimeRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );
    List<String> images = [];

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            ImageInputWidget(
              getImages: (images) {},
            ),
            const SizedBox(height: 16),
            TitleDescInput(
              getTitle: (title) {},
              getDescription: (description) {},
            ),
            const SizedBox(height: 16),
            CategoryInputWidget(
              getCategory: (categoryIndex) {},
            ),
            const SizedBox(height: 16),
            AmountsInputWidget(
              getCashAmount: (cashAmount) {},
              getPeopleAmount: (peopleAmount) {},
            ),
            const SizedBox(height: 16),
            LocationInputWidget(
              getLocation: (location) {},
            ),
            const SizedBox(height: 16),
            DateTimeRangeInputWidget(
              getStartDate: (dateTime) {},
              getEndDate: (dateTime) {},
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: FilledButton.icon(
                onPressed: () {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    NoticeDetails noticeDetails = NoticeDetails(
                      id: 'id',
                      userId: 'userId',
                      title: title,
                      description: description,
                      category: category,
                      cashAmount: cashAmount,
                      peopleAmount: peopleAmount,
                      location: location,
                      dateTimeRange: dateTimeRange,
                      imagesUrl: images,
                    );

                    context.read<CreateNoticeBloc>().add(
                          CreateNoticeDetailsEvent(
                            noticeDetails: noticeDetails,
                          ),
                        );

                    print('dodano');
                  }
                },
                label: const Text('DODAJ OGŁOSZENIE'),
                icon: const Icon(Icons.note_add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
