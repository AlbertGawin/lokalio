import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:lokalio/core/util/lok_show_modal_bottom_sheet.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/card_widget.dart';

class ImageInputWidget extends StatefulWidget {
  const ImageInputWidget({super.key, required this.getImages});

  final void Function(List<String> images) getImages;

  @override
  State<ImageInputWidget> createState() => _ImageInputWidgetState();
}

class _ImageInputWidgetState extends State<ImageInputWidget> {
  final List<String> _imagesOriginal = [];
  final List<String> _imagesToSend = [];

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(4);
    final border = Border.all(color: Theme.of(context).colorScheme.primary);
    final addPhotoIcon = Icon(Icons.add_photo_alternate_outlined,
        color: Theme.of(context).colorScheme.primary);

    return CardWidget(
      title: 'Zdjęcia',
      content: [
        if (_imagesToSend.isEmpty)
          buildAddPhotoContainer(
            () => lokShowModalBottomSheet(
              context: context,
              titleList: ['Zrób zdjęcie', 'Wybierz zdjęcia'],
              leadingList: [Icons.camera_alt, Icons.image],
              onTapList: [_uploadImage, _chooseFromGallery],
            ),
            borderRadius,
            border,
            addPhotoIcon,
          )
        else
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: borderRadius,
                ),
              ),
              SizedBox(
                height: 60,
                child: ReorderableListView.builder(
                  proxyDecorator: (child, index, animation) => child,
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagesToSend.length,
                  itemBuilder: (context, index) => buildImageCard(
                    index,
                    borderRadius,
                  ),
                  onReorder: ((oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final String path = _imagesOriginal.removeAt(oldIndex);
                    _imagesOriginal.insert(newIndex, path);
                    final String pathToSend = _imagesToSend.removeAt(oldIndex);
                    _imagesToSend.insert(newIndex, pathToSend);

                    widget.getImages(_imagesToSend);
                  }),
                ),
              ),
              if (_imagesToSend.length < 4)
                Positioned(
                  left: _imagesToSend.length * 68.0 + 4.0,
                  child: buildShowPhotoContainer(
                    () => lokShowModalBottomSheet(
                      context: context,
                      titleList: ['Zrób zdjęcie', 'Wybierz zdjęcia'],
                      leadingList: [Icons.camera_alt, Icons.image],
                      onTapList: [_uploadImage, _chooseFromGallery],
                    ),
                    borderRadius,
                    border,
                    addPhotoIcon,
                  ),
                ),
            ],
          ),
        Text(
          _imagesToSend.isEmpty
              ? 'Dodaj do 4 zdjęć ogłoszenia.'
              : 'Dodano ${_imagesToSend.length} z 4 zdjęć. Przeciągnij miniaturki, aby zmienić kolejność. Dotknij, aby zobaczyć więcej opcji.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget buildImageCard(int index, BorderRadius borderRadius) {
    return Card(
      key: Key(index.toString()),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => lokShowModalBottomSheet(
          context: context,
          titleList: ['Edytuj', 'Usuń'],
          leadingList: [Icons.edit, Icons.delete],
          onTapList: [
            () => _editImage(path: _imagesOriginal[index], index: index),
            () => _deleteImage(index: index)
          ],
        ),
        child: Ink.image(
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          image: FileImage(
            File(_imagesToSend[index]),
          ),
        ),
      ),
    );
  }

  Widget buildAddPhotoContainer(
    VoidCallback onTap,
    BorderRadius borderRadius,
    Border border,
    Icon addPhotoIcon,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        width: double.infinity,
        height: 68,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
          borderRadius: borderRadius,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              'DODAJ ZDJĘCIA',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShowPhotoContainer(
    VoidCallback onTap,
    BorderRadius borderRadius,
    Border border,
    Icon addPhotoIcon,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
          borderRadius: borderRadius,
          border: border,
        ),
        child: addPhotoIcon,
      ),
    );
  }

  Future<void> _uploadImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 100,
    );

    if (pickedImage == null) return;

    _imagesOriginal.add(pickedImage.path);
    _imagesToSend.add(pickedImage.path);

    setState(() {
      widget.getImages(_imagesToSend);
    });
  }

  Future<void> _chooseFromGallery() async {
    final ImagePickerPlatform imagePicker = ImagePickerPlatform.instance;
    if (imagePicker is ImagePickerAndroid) {
      imagePicker.useAndroidPhotoPicker = true;
    }

    final pickedImages = await ImagePicker().pickMultiImage(
      maxHeight: 1280,
      maxWidth: 1280,
      imageQuality: 80,
    );

    if (pickedImages.isEmpty) return;

    for (final pickedImage in pickedImages) {
      if (_imagesOriginal.length == 4) {
        break;
      }

      _imagesOriginal.add(pickedImage.path);
      _imagesToSend.add(pickedImage.path);
    }

    setState(() {
      widget.getImages(_imagesToSend);
    });
  }

  Future<void> _editImage({required String path, required int index}) async {
    final editedImage = await ImageCropper().cropImage(
      sourcePath: path,
      compressQuality: 100,
    );

    if (editedImage == null) return;

    _imagesToSend[index] = editedImage.path;

    setState(() {
      widget.getImages(_imagesToSend);
    });
  }

  void _deleteImage({required int index}) {
    setState(() {
      _imagesOriginal.removeAt(index);
      _imagesToSend.removeAt(index);
    });
  }
}
