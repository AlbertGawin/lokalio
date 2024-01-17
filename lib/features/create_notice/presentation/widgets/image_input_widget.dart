import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/card_widget.dart';

class ImageInputWidget extends StatefulWidget {
  const ImageInputWidget({
    super.key,
    required this.getImages,
  });

  final void Function(List<String> images) getImages;

  @override
  State<ImageInputWidget> createState() => _ImageInputWidgetState();
}

class _ImageInputWidgetState extends State<ImageInputWidget> {
  final List<String> _imagesPaths = [];

  Future<void> _uploadImage() async {
    Navigator.of(context).pop();

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 100,
    );

    if (pickedImage != null) {
      _imagesPaths.add(pickedImage.path);

      setState(() {
        widget.getImages(_imagesPaths);
      });
    }
  }

  Future<void> _chooseFromGallery() async {
    Navigator.of(context).pop();

    final ImagePickerPlatform imagePickerImplementation =
        ImagePickerPlatform.instance;

    if (imagePickerImplementation is ImagePickerAndroid) {
      imagePickerImplementation.useAndroidPhotoPicker = true;
    }

    final pickedImages = await ImagePicker().pickMultiImage(
      maxHeight: 1280,
      maxWidth: 1280,
      imageQuality: 100,
    );

    if (pickedImages.isNotEmpty) {
      for (XFile pickedImage in pickedImages) {
        if (_imagesPaths.length == 4) {
          break;
        }

        _imagesPaths.add(pickedImage.path);
      }

      setState(() {
        widget.getImages(_imagesPaths);
      });
    }
  }

  Future<void> _editImage({required String path, required int index}) async {
    Navigator.of(context).pop();

    await ImageCropper()
        .cropImage(
      sourcePath: path,
      compressQuality: 100,
    )
        .then((editedImage) async {
      if (editedImage != null) {
        _imagesPaths[index] = editedImage.path;

        setState(() {
          widget.getImages(_imagesPaths);
        });
      }
    });
  }

  void _deleteImage({required int index}) {
    Navigator.of(context).pop();

    setState(() {
      _imagesPaths.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'Zdjęcia',
      content: [
        if (_imagesPaths.isEmpty)
          InkWell(
            onTap: () => lokShowModalBottomSheet(
              context: context,
              titleList: ['Zrób zdjęcie', 'Wybierz zdjęcia'],
              leadingList: [Icons.camera_alt, Icons.image],
              onTapList: [_uploadImage, _chooseFromGallery],
            ),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: double.infinity,
              height: 68,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(
                height: 60,
                child: ReorderableListView.builder(
                  proxyDecorator: (child, index, animation) => child,
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagesPaths.length,
                  itemBuilder: (context, index) {
                    return Card(
                      key: Key(index.toString()),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => lokShowModalBottomSheet(
                          context: context,
                          titleList: ['Edytuj', 'Usuń'],
                          leadingList: [Icons.edit, Icons.delete],
                          onTapList: [
                            () => _editImage(
                                  path: _imagesPaths[index],
                                  index: index,
                                ),
                            () => _deleteImage(index: index)
                          ],
                        ),
                        child: Ink.image(
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          image: FileImage(
                            File(_imagesPaths[index]),
                          ),
                        ),
                      ),
                    );
                  },
                  onReorder: ((oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final String path = _imagesPaths.removeAt(oldIndex);
                    _imagesPaths.insert(newIndex, path);

                    widget.getImages(_imagesPaths);
                  }),
                ),
              ),
              if (_imagesPaths.length < 4)
                Row(
                  children: [
                    SizedBox(width: (_imagesPaths.length) * 68 + 4),
                    InkWell(
                      onTap: () => lokShowModalBottomSheet(
                        context: context,
                        titleList: ['Zrób zdjęcie', 'Wybierz zdjęcia'],
                        leadingList: [Icons.camera_alt, Icons.image],
                        onTapList: [_uploadImage, _chooseFromGallery],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
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
          ),
        Text(
          _imagesPaths.isEmpty
              ? 'Dodaj do 4 zdjęć ogłoszenia.'
              : 'Dodano ${_imagesPaths.length} z 4 zdjęć. Przeciągnij miniaturki, aby zmienić kolejność. Dotknij, aby zobaczyć więcej opcji.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

void lokShowModalBottomSheet({
  required BuildContext context,
  required List<String> titleList,
  required List<IconData?> leadingList,
  required List<Function()?> onTapList,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < titleList.length; index++)
            ListTile(
              onTap: onTapList[index],
              title: Text(titleList[index]),
              leading: Icon(leadingList[index]),
            ),
          ListTile(
            onTap: () => Navigator.of(context).pop(),
            title: const Text(
              'ANULUJ',
              textAlign: TextAlign.center,
            ),
            textColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      );
    },
  );
}
