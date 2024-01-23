import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/amounts_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/category_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/date_time_range_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/location_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/title_desc__input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/images_input_widget.dart';
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
    int peopleAmount = 1;
    LatLng location = const LatLng(0, 0);
    DateTimeRange dateTimeRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );
    List<String>? images;

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            ImagesInputWidget(
              getImages: (imagesData) {
                images = imagesData;
              },
            ),
            const SizedBox(height: 16),
            TitleDescInputWidget(
              getTitle: (titleData) {
                title = titleData;
              },
              getDescription: (descriptionData) {
                description = descriptionData;
              },
            ),
            const SizedBox(height: 16),
            CategoryInputWidget(
              getCategory: (categoryIndexData) {
                category = categoryIndexData;
              },
            ),
            const SizedBox(height: 16),
            AmountsInputWidget(
              getCashAmount: (cashAmountData) {
                cashAmount = cashAmountData;
              },
              getPeopleAmount: (peopleAmountData) {
                peopleAmount = peopleAmountData;
              },
            ),
            const SizedBox(height: 16),
            LocationInputWidget(
              getLocation: (locationData) {
                location = locationData;
              },
            ),
            const SizedBox(height: 16),
            DateTimeRangeInputWidget(
              getDateTimeRange: (dateTimeRangeData) {
                dateTimeRange = dateTimeRangeData;
              },
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: FilledButton.icon(
                onPressed: () {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    final User? user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      throw FirebaseAuthException(
                        code: 'USER_NOT_LOGGED_IN',
                        message: 'User is not logged in.',
                      );
                    }

                    final NoticeDetails noticeDetails = NoticeDetails(
                      id: '',
                      userId: user.uid,
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
