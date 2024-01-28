import 'package:flutter/material.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/card_widget.dart';

class TitleDescInputWidget extends StatefulWidget {
  const TitleDescInputWidget({
    super.key,
    required this.getTitle,
    required this.getDescription,
  });

  final void Function(String title) getTitle;
  final void Function(String description) getDescription;

  @override
  State<TitleDescInputWidget> createState() => _TitleDescInputWidgetState();
}

class _TitleDescInputWidgetState extends State<TitleDescInputWidget> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'Tytuł i opis*',
      content: [
        buildTextFormField(
          controller: _titleController,
          label: 'Tytuł*',
          errorMessage: 'Tytuł musi posiadać minimum 5 znaków.',
          onSaved: widget.getTitle,
          minLength: 5,
          maxLength: 50,
          autocorrect: false,
        ),
        buildTextFormField(
          controller: _descController,
          label: 'Opis*',
          errorMessage: 'Opis musi posiadać minimum 10 znaków.',
          onSaved: widget.getDescription,
          minLength: 10,
          maxLength: 200,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }

  TextFormField buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String errorMessage,
    required void Function(String value) onSaved,
    int minLength = 0,
    int maxLength = 200,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool autocorrect = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: autocorrect,
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.trim().length < minLength) {
          return errorMessage;
        }
        return null;
      },
      onSaved: (value) {
        if (value != null) {
          onSaved(value.trim());
        }
      },
    );
  }
}
