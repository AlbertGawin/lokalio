import 'package:flutter/material.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/amounts_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/category_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/date_time_range_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/location_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/title_desc_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/image_input_widget.dart';

class CreateNoticeWidget extends StatelessWidget {
  const CreateNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Form(
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
                  onPressed: () {},
                  label: const Text('DODAJ OGŁOSZENIE'),
                  icon: const Icon(Icons.note_add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
