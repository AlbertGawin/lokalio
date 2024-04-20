import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/core/util/lok_show_modal_bottom_sheet.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';

class ImagesInput extends StatelessWidget {
  const ImagesInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoticeCubit, CreateNoticeState>(
        buildWhen: (previous, current) => previous.images != current.images,
        builder: (context, state) {
          return FormField(
              key: const Key('createNotice_imagesInput_textField'),
              builder: (FormFieldState formState) {
                final images = state.images.value;
                final cubit = context.read<CreateNoticeCubit>();

                return images.isEmpty
                    ? _buildAddImagesInkWell(context, cubit)
                    : _buildImagesStack(context, cubit, images);
              });
        });
  }

  InkWell _buildAddImagesInkWell(
      BuildContext context, CreateNoticeCubit cubit) {
    return InkWell(
      onTap: () => lokShowModalBottomSheet(
        context: context,
        titleList: ['Zrób zdjęcie', 'Wybierz zdjęcia'],
        leadingList: [Icons.camera_alt, Icons.image],
        onTapList: [
          () => cubit.addFromCamera(),
          () => cubit.addFromGallery(),
        ],
      ),
      child: Container(
        width: double.infinity,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined),
            SizedBox(width: 10),
            Text('DODAJ ZDJĘCIA'),
          ],
        ),
      ),
    );
  }

  Stack _buildImagesStack(
      BuildContext context, CreateNoticeCubit cubit, List<String> images) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(
          height: 60,
          child: ReorderableListView.builder(
            proxyDecorator: (child, index, animation) => child,
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Card(
                key: Key(index.toString()),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () => lokShowModalBottomSheet(
                    context: context,
                    titleList: ['Edytuj', 'Usuń'],
                    leadingList: [Icons.edit, Icons.delete],
                    onTapList: [
                      () => cubit.editImage(
                            images[index],
                            index,
                          ),
                      () => cubit.removeImage(index),
                    ],
                  ),
                  child: Ink.image(
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(images[index]),
                    ),
                  ),
                ),
              );
            },
            onReorder: ((oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final String path = images.removeAt(oldIndex);
              images.insert(newIndex, path);
            }),
          ),
        ),
        if (images.length < 4)
          Row(
            children: [
              SizedBox(width: (images.length) * 68 + 4),
              InkWell(
                onTap: () => lokShowModalBottomSheet(
                  context: context,
                  titleList: ['Zrób zdjęcie', 'Wybierz zdjęcia'],
                  leadingList: [Icons.camera_alt, Icons.image],
                  onTapList: [
                    () => cubit.addFromCamera(),
                    () => cubit.addFromGallery(),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
