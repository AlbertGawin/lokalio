import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/card_widget.dart';

class DateTimeRangeInputWidget extends StatefulWidget {
  const DateTimeRangeInputWidget({super.key, required this.getDateTimeRange});

  final void Function(DateTimeRange dateTimeRange) getDateTimeRange;

  @override
  State<DateTimeRangeInputWidget> createState() =>
      _DateTimeRangeInputWidgetState();
}

class _DateTimeRangeInputWidgetState extends State<DateTimeRangeInputWidget> {
  final TextEditingController _startDateInput = TextEditingController();
  final TextEditingController _endDateInput = TextEditingController();
  final DateFormat formatter = DateFormat.yMMMMd();

  @override
  void dispose() {
    _startDateInput.dispose();
    _endDateInput.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'Data*',
      cornerWidget: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _showDateRangePicker(),
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
              child: _buildDateField(
                controller: _startDateInput,
                labelText: 'Data początkowa',
                onTap: () => _updateDateRange(isStart: true),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildDateField(
                controller: _endDateInput,
                labelText: 'Data końcowa',
                onTap: () => _updateDateRange(isStart: false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Podaj datę.';
        }
        return null;
      },
      onTap: onTap,
    );
  }

  DateTime _getStartDate() {
    final DateTime now = DateTime.now();
    return _startDateInput.text.isNotEmpty
        ? formatter.parse(_startDateInput.text)
        : now;
  }

  DateTime _getEndDate() {
    final DateTime now = DateTime.now();
    return _endDateInput.text.isNotEmpty
        ? formatter.parse(_endDateInput.text)
        : now.add(const Duration(days: 365));
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDateRange != null) {
      final formattedStartDate = formatter.format(pickedDateRange.start);
      final formattedEndDate = formatter.format(pickedDateRange.end);

      setState(() {
        _startDateInput.text = formattedStartDate;
        _endDateInput.text = formattedEndDate;
      });

      widget.getDateTimeRange(pickedDateRange);
    }
  }

  Future<void> _updateDateRange({required bool isStart}) async {
    final DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final DateTime startDate = _getStartDate();
    final DateTime endDate = _getEndDate();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart
          ? startDate
          : _endDateInput.text.isEmpty
              ? startDate
              : endDate,
      firstDate: isStart ? now : startDate,
      lastDate: isStart ? endDate : now.add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final formattedDate = formatter.format(pickedDate);

      setState(() {
        if (isStart) {
          _startDateInput.text = formattedDate;
        } else {
          _endDateInput.text = formattedDate;
        }
      });

      widget.getDateTimeRange(DateTimeRange(
        start: isStart ? pickedDate : startDate,
        end: isStart ? endDate : pickedDate,
      ));
    }
  }
}
