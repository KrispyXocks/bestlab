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

  void _selectNow() {
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    formattedDate = "${formattedDate}Z";

    setState(() {
      _selectedToDateTime = formattedDate;
    });

    // Tự động áp dụng URL với thời gian "to" là now và từ "from" đã chọn
    if (_selectedFromDateTime != "Select From Date & Time") {
      String newUrl = '$_baseUrl&from=$_selectedFromDateTime&to=$_selectedToDateTime';
      _webViewController.loadUrl(newUrl);
    } else {
      // Hiển thị cảnh báo nếu người dùng chưa chọn thời gian "from"
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Please select a From time range before applying Now."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(width: 10),
                    Text(
                      _selectedFromDateTime,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'To:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: _selectNow,
                    ),
                    SizedBox(width: 10),
                    Text(
                      _selectedToDateTime,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.5,
              child: WebView(
                initialUrl: _baseUrl,
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
