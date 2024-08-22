import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DateTimeRangePickerExample extends StatefulWidget {
  @override
  _DateTimeRangePickerExampleState createState() => _DateTimeRangePickerExampleState();
}

class _DateTimeRangePickerExampleState extends State<DateTimeRangePickerExample> {
  String _selectedFromDateTime = "Select From Date & Time";
  String _selectedToDateTime = "Select To Date & Time";
  String _baseUrl = "http://10.0.2.2:3000/d-solo/TXSTREZ/simple-streaming-example?orgId=1&panelId=5";
  late WebViewController _webViewController;

  final String _defaultFromDateTime = "2024-01-01T00:00:00Z"; // Giá trị mặc định cho "from"
  final String _defaultToDateTime = "now"; // Giá trị mặc định cho "to"

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
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
        initialEntryMode: TimePickerEntryMode.input, // Đặt chế độ nhập text
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
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
        initialEntryMode: TimePickerEntryMode.input, // Đặt chế độ nhập text
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
    setState(() {
      _selectedToDateTime = "now";
    });

    // Tự động áp dụng URL với thời gian "to" là "now" và từ "from" đã chọn
    _applyTimeRange();
  }

  void _applyTimeRange() {
    String fromTime = _selectedFromDateTime != "Select From Date & Time"
        ? _selectedFromDateTime
        : _defaultFromDateTime;
    String toTime = _selectedToDateTime != "Select To Date & Time"
        ? _selectedToDateTime
        : _defaultToDateTime;

    String newUrl = '$_baseUrl&from=$fromTime&to=$toTime';

    // Tạo nội dung HTML với iframe
    String iframeHtml = '''
      <html>
        <body style="margin:0;padding:0;">
          <iframe src="$newUrl" style="border:none;" width="100%" height="50%"></iframe>
        </body>
      </html>
    ''';

    _webViewController.loadUrl(Uri.dataFromString(iframeHtml, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DateTime Range Picker Example'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      'From:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _selectFromDateTime(context),
                    ),
                    Expanded(
                      child: Text(
                        _selectedFromDateTime,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Text(
                      'To:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _selectToDateTime(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: _selectNow,
                    ),
                    Expanded(
                      child: Text(
                        _selectedToDateTime,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _applyTimeRange,
                  child: Text('Apply Time Range'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.5,
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _webViewController = webViewController;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DateTimeRangePickerExample(),
  ));
}
