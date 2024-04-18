import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:lokalio/core/util/compress_image.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/src/category.dart';
import 'package:lokalio/features/create_notice/presentation/src/description.dart';
import 'package:lokalio/features/create_notice/presentation/src/images.dart';
import 'package:lokalio/features/create_notice/presentation/src/money_amount.dart';
import 'package:lokalio/features/create_notice/presentation/src/people_amount.dart';
import 'package:lokalio/features/create_notice/presentation/src/title.dart';

class CreateNoticeCubit extends Cubit<CreateNoticeState> {
  CreateNoticeCubit() : super(const CreateNoticeState());

  Future<void> addFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage != null) {
      await compressImage(path: pickedImage.path).then((image) {
        _addImage(image);
      });
    }
  }

  Future<void> addFromGallery() async {
    final ImagePickerPlatform imagePickerImplementation =
        ImagePickerPlatform.instance;

    if (imagePickerImplementation is ImagePickerAndroid) {
      imagePickerImplementation.useAndroidPhotoPicker = true;
    }

    await ImagePicker().pickMultiImage().then((images) async {
      if (images.isNotEmpty) {
        for (XFile image in images) {
          await compressImage(path: image.path).then((image) {
            _addImage(image);
          });
        }
      }
    });
  }

  Future<void> editImage(String image, int index) async {
    await ImageCropper()
        .cropImage(sourcePath: image, compressQuality: 100)
        .then((editedImage) async {
      if (editedImage != null) {
        _updateImage(index, editedImage.path);
      }
    });
  }

  void _addImage(String value) {
    final images = Images.dirty([...state.images.value, value]);

    if (images.value.length > 4) {
      return;
    }
    emit(state.copyWith(images: images, isValid: Formz.validate([images])));
  }

  void _updateImage(int index, String value) {
    final images = Images.dirty(List<String>.from(state.images.value)
      ..replaceRange(index, index + 1, [value]));
    emit(state.copyWith(images: images, isValid: Formz.validate([images])));
  }

  void removeImage(int index) {
    final images =
        Images.dirty(List<String>.from(state.images.value)..removeAt(index));
    emit(state.copyWith(images: images, isValid: Formz.validate([images])));
  }

  void titleChanged(String value) {
    final title = Title.dirty(value);
    emit(state.copyWith(title: title, isValid: Formz.validate([title])));
  }

  void descriptionChanged(String value) {
    final description = Description.dirty(value);
    emit(state.copyWith(
        description: description, isValid: Formz.validate([description])));
  }

  void categoryChanged(int value) {
    final category = Category.dirty(value);
    emit(state.copyWith(
        category: category, isValid: Formz.validate([category])));
  }

  void moneyAmountChanged(String value) {
    final moneyAmount = MoneyAmount.dirty(value);
    emit(state.copyWith(
        moneyAmount: moneyAmount, isValid: Formz.validate([moneyAmount])));
  }

  void peopleAmountChanged(String value) {
    final peopleAmount = PeopleAmount.dirty(value);
    emit(state.copyWith(
        peopleAmount: peopleAmount, isValid: Formz.validate([peopleAmount])));
  }
}
