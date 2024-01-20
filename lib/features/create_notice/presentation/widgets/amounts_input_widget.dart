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
        TextFormField(
          controller: _cashController,
          maxLines: 1,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d{0,2}')),
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text('Kwota*'),
            suffix: Text('zł'),
            counterText: '',
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Podaj kwotę.';
            }
            return null;
          },
          onSaved: (newValue) {
            if (newValue != null) {
              widget.getCashAmount(int.tryParse(newValue)!);
            }
          },
        ),
        TextFormField(
          controller: _peopleController,
          maxLength: 2,
          maxLines: 1,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*')),
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text('Liczba osób*'),
            counterText: '',
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Podaj liczbę potrzebnych osób.';
            }
            return null;
          },
          onSaved: (newValue) {
            if (newValue != null) {
              widget.getPeopleAmount(int.tryParse(newValue)!);
            }
          },
        ),
      ],
    );
  }
}
