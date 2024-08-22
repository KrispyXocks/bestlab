import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DateTimeRangePickerExample extends StatefulWidget {
  @override
  _DateTimeRangePickerExampleState createState() => _DateTimeRangePickerExampleState();
}

class _DateTimeRangePickerExampleState extends State<DateTimeRangePickerExample> {
  String _selectedFromDateTime = "Select From Date & Time";
  String _selectedToDateTime = "Select To Date & Time";
  String _baseUrl = "http://localhost:3000/d-solo/TXSTREZ/simple-streaming-example?orgId=1&panelId=5";
  late WebViewController _webViewController;

  final String _defaultFromDateTime = "2024-01-01T00:00:00Z"; // Giá trị mặc định cho "from"
  final String _defaultToDateTime = "now"; // Giá trị mặc định cho "to"

  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  Future<void> _selectFromDateTime(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TabBar(
                  tabs: [
                    Tab(text: "Date"),
                    Tab(text: "Time"),
                  ],
                ),
                Container(
                  height: 300, // Chiều cao của TabBarView
                  child: TabBarView(
                    children: [
                      // Tab Date Picker
                      Center(
                        child: SizedBox(
                          height: 250,
                          child: CalendarDatePicker(
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            onDateChanged: (date) {
                              selectedDate = date;
                            },
                          ),
                        ),
                      ),
                      // Tab Time Picker Custom
                      Center(
                        child: SizedBox(
                          height: 250,
                          child: _buildCustomTimePicker(),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedDate != null && selectedTime != null) {
                          final DateTime fullDateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                          String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(fullDateTime);
                          formattedDate = "${formattedDate}Z";

                          setState(() {
                            _selectedFromDateTime = formattedDate;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectToDateTime(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TabBar(
                  tabs: [
                    Tab(text: "Date"),
                    Tab(text: "Time"),
                  ],
                ),
                Container(
                  height: 300, // Chiều cao của TabBarView
                  child: TabBarView(
                    children: [
                      // Tab Date Picker
                      Center(
                        child: SizedBox(
                          height: 250,
                          child: CalendarDatePicker(
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            onDateChanged: (date) {
                              selectedDate = date;
                            },
                          ),
                        ),
                      ),
                      // Tab Time Picker Custom
                      Center(
                        child: SizedBox(
                          height: 250,
                          child: _buildCustomTimePicker(),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedDate != null && selectedTime != null) {
                          final DateTime fullDateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                          String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(fullDateTime);
                          formattedDate = "${formattedDate}Z";

                          setState(() {
                            _selectedToDateTime = formattedDate;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomTimePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          value: selectedTime!.hour,
          minValue: 0,
          maxValue: 23,
          onChanged: (value) {
            setState(() {
              selectedTime = TimeOfDay(hour: value, minute: selectedTime!.minute);
            });
          },
        ),
        Text(":"),
        NumberPicker(
          value: selectedTime!.minute,
          minValue: 0,
          maxValue: 59,
          onChanged: (value) {
            setState(() {
              selectedTime = TimeOfDay(hour: selectedTime!.hour, minute: value);
            });
          },
        ),
      ],
    );
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
