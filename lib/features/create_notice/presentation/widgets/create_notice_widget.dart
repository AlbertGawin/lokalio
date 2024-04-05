import 'package:cloud_firestore/cloud_firestore.dart';
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

    Map<String, dynamic> data = {
      'title': '',
      'description': '',
      'category': 0,
      'moneyAmount': 0,
      'peopleAmount': 1,
      'location': const LatLng(0, 0),
      'dateTimeRange': DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
      'images': null,
    };

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: FilledButton.icon(
          onPressed: () => _validate(context, formKey, data),
          label: const Text('DODAJ OGŁOSZENIE'),
          icon: const Icon(Icons.note_add),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              ImagesInputWidget(
                getImages: (imagesData) {
                  data['images'] = imagesData;
                },
              ),
              const SizedBox(height: 8),
              TitleDescInputWidget(
                getTitle: (titleData) {
                  data['title'] = titleData;
                },
                getDescription: (descriptionData) {
                  data['description'] = descriptionData;
                },
              ),
              const SizedBox(height: 8),
              CategoryInputWidget(
                getCategory: (categoryIndexData) {
                  data['category'] = categoryIndexData;
                },
              ),
              const SizedBox(height: 8),
              AmountsInputWidget(
                getmoneyAmount: (moneyAmountData) {
                  data['moneyAmount'] = moneyAmountData;
                },
                getPeopleAmount: (peopleAmountData) {
                  data['peopleAmount'] = peopleAmountData;
                },
              ),
              const SizedBox(height: 8),
              LocationInputWidget(
                getLocation: (locationData) {
                  data['location'] = locationData;
                },
              ),
              const SizedBox(height: 8),
              DateTimeRangeInputWidget(
                getDateTimeRange: (dateTimeRangeData) {
                  data['dateTimeRange'] = dateTimeRangeData;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validate(
    BuildContext context,
    GlobalKey<FormState> formKey,
    Map<String, dynamic> data,
  ) {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
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
        title: data['title'],
        category: data['category'],
        moneyAmount: data['moneyAmount'],
        location: data['location'],
        description: data['description'],
        peopleAmount: data['peopleAmount'],
        imagesUrl: data['images'],
        createdAt: Timestamp.now(),
      );

      context
          .read<CreateNoticeBloc>()
          .add(CreateNoticeDetailsEvent(noticeDetails: noticeDetails));
    }
  }
}
