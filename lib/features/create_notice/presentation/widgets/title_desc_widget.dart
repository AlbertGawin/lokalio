import 'package:flutter/material.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/card_widget.dart';

class TitleDescInput extends StatefulWidget {
  const TitleDescInput({
    super.key,
    required this.getTitle,
    required this.getDescription,
  });

  final void Function(String title) getTitle;
  final void Function(String description) getDescription;

  @override
  State<TitleDescInput> createState() => _TitleDescInputState();
}

class _TitleDescInputState extends State<TitleDescInput> {
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
      title: 'Tytuł i opis',
      content: [
        TextFormField(
          controller: _titleController,
          textCapitalization: TextCapitalization.sentences,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          maxLength: 50,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Tytuł*',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Tytuł nie może być pusty.';
            }
            return null;
          },
          onSaved: (newValue) {
            if (newValue != null) {
              widget.getTitle(newValue);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descController,
          textCapitalization: TextCapitalization.sentences,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: 200,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Opis',
          ),
          validator: (value) {
            if (value == null || value.trim().length < 10) {
              return 'Opis musi posiadać minimum 10 znaków.';
            }
            return null;
          },
          onSaved: (newValue) {
            if (newValue != null) {
              widget.getDescription(newValue);
            }
          },
        ),
      ],
    );
  }
}
