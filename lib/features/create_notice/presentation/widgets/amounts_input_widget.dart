import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/card_widget.dart';

class AmountsInputWidget extends StatefulWidget {
  const AmountsInputWidget({
    super.key,
    required this.getCashAmount,
    required this.getPeopleAmount,
  });

  final void Function(int cashAmount) getCashAmount;
  final void Function(int peopleAmount) getPeopleAmount;

  @override
  State<AmountsInputWidget> createState() => _AmountsInputWidgetState();
}

class _AmountsInputWidgetState extends State<AmountsInputWidget> {
  final _cashController = TextEditingController();
  final _peopleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _peopleController.text = '1';
  }

  @override
  void dispose() {
    _cashController.dispose();
    _peopleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'Kwota i liczba osób*',
      content: [
        buildTextFormField(
          controller: _cashController,
          label: 'Kwota*',
          errorMessage: 'Podaj kwotę.',
          onSaved: widget.getCashAmount,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d{0,2}')),
          ],
          suffix: 'zł',
        ),
        buildTextFormField(
          controller: _peopleController,
          label: 'Liczba osób*',
          errorMessage: 'Podaj liczbę potrzebnych osób.',
          onSaved: widget.getPeopleAmount,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*')),
          ],
          maxLength: 2,
        ),
      ],
    );
  }

  TextFormField buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String errorMessage,
    required void Function(int value) onSaved,
    TextInputType keyboardType =
        const TextInputType.numberWithOptions(decimal: true, signed: false),
    List<TextInputFormatter>? inputFormatters,
    String? suffix,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(label),
        suffix: suffix != null ? Text(suffix) : null,
        counterText: '',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorMessage;
        }
        return null;
      },
      onSaved: (newValue) {
        if (newValue != null) {
          onSaved(int.parse(newValue));
        }
      },
    );
  }
}
