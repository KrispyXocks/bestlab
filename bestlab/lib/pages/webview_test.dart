import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeRangePickerExample extends StatefulWidget {
  @override
  _DateTimeRangePickerExampleState createState() => _DateTimeRangePickerExampleState();
}

class _DateTimeRangePickerExampleState extends State<DateTimeRangePickerExample> {
  String _selectedFromDateTime = "Select From Date & Time";
  String _selectedToDateTime = "Select To Date & Time";

  Future<void> _selectFromDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(fullDateTime);
        formattedDate = "${formattedDate}Z";

        setState(() {
          _selectedFromDateTime = formattedDate;
        });
      }
    }
  }

  Future<void> _selectToDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(fullDateTime);
        formattedDate = "${formattedDate}Z";

        setState(() {
          _selectedToDateTime = formattedDate;
        });
      }
    }
  }

  void _selectNow() {
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    formattedDate = "${formattedDate}Z";

    setState(() {
      _selectedToDateTime = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DateTime Range Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selected From DateTime:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _selectedFromDateTime,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectFromDateTime(context),
              child: Text('Pick From Date & Time'),
            ),
            SizedBox(height: 20),
            Text(
              'Selected To DateTime:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _selectedToDateTime,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectToDateTime(context),
              child: Text('Pick To Date & Time'),
            ),
            ElevatedButton(
              onPressed: _selectNow,
              child: Text('Set To Now'),
            ),
          ],
        ),
      ),
    );
  }
}
