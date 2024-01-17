import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/card_widget.dart';

class DateTimeRangeInputWidget extends StatefulWidget {
  const DateTimeRangeInputWidget({
    super.key,
    required this.getStartDate,
    required this.getEndDate,
  });

  final void Function(DateTime dateTime) getStartDate;
  final void Function(DateTime dateTime) getEndDate;

  @override
  State<DateTimeRangeInputWidget> createState() =>
      _DateTimeRangeInputWidgetState();
}

class _DateTimeRangeInputWidgetState extends State<DateTimeRangeInputWidget> {
  final TextEditingController _startDateInput = TextEditingController();
  final TextEditingController _endDateInput = TextEditingController();

  @override
  void dispose() {
    _startDateInput.dispose();
    _endDateInput.dispose();

    super.dispose();
  }

  void _chooseDateRange() async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
    );

    if (pickedDateRange != null) {
      final start = DateFormat.yMMMMd().format(pickedDateRange.start);
      final end = DateFormat.yMMMMd().format(pickedDateRange.end);

      setState(() {
        _startDateInput.text = start;
        _endDateInput.text = end;
      });

      widget.getStartDate(pickedDateRange.start);
      widget.getEndDate(pickedDateRange.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'Data*',
      cornerWidget: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: _chooseDateRange,
        child: Text(
          'WYBIERZ ZAKRES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      content: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _startDateInput,
                decoration: const InputDecoration(
                  labelText: 'Data początkowa',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Podaj datę początkową.';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? endDate;
                  if (_endDateInput.text.isNotEmpty) {
                    endDate = DateFormat.yMMMMd().parse(_endDateInput.text);
                  }

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: endDate ??
                        DateTime.now().add(
                          const Duration(days: 365),
                        ),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat.yMMMMd().format(pickedDate);

                    setState(() {
                      _startDateInput.text = formattedDate;
                    });

                    widget.getStartDate(pickedDate);
                  }
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: _endDateInput,
                decoration: const InputDecoration(
                  labelText: 'Data końcowa',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Podaj datę końcową.';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? startDate;
                  if (_startDateInput.text.isNotEmpty) {
                    startDate = DateFormat.yMMMMd().parse(_startDateInput.text);
                  }

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat.yMMMMd().format(pickedDate);

                    setState(() {
                      _endDateInput.text = formattedDate;
                    });

                    widget.getEndDate(pickedDate);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
