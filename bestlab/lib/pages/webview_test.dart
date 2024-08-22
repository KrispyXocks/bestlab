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

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_webViewController != null) {
        await _webViewController.loadUrl(Uri.dataFromString('''
        <html>
          <body style="margin:0;padding:0;">
            <iframe src="$_baseUrl" style="border:none;" width="100%" height="100%"></iframe>
          </body>
        </html>
      ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
      }
    });
  }

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
                  height: 300,
                  child: TabBarView(
                    children: [
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
                      Center(
                        child: SizedBox(
                          height: 250,
                          child: _buildTimePickerInput(),
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
                        if (selectedDate != null && _hourController.text.isNotEmpty && _minuteController.text.isNotEmpty) {
                          final DateTime fullDateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            int.parse(_hourController.text),
                            int.parse(_minuteController.text),
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
                  height: 300,
                  child: TabBarView(
                    children: [
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
                      Center(
                        child: SizedBox(
                          height: 250,
                          child: _buildTimePickerInput(),
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
                        if (selectedDate != null && _hourController.text.isNotEmpty && _minuteController.text.isNotEmpty) {
                          final DateTime fullDateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            int.parse(_hourController.text),
                            int.parse(_minuteController.text),
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

  Widget _buildTimePickerInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          child: TextField(
            controller: _hourController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Hour",
              labelStyle: TextStyle(fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: UnderlineInputBorder(),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Text(
          ":",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: _minuteController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Min",
              labelStyle: TextStyle(fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: UnderlineInputBorder(),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }




  void _selectNow() {
    setState(() {
      _selectedToDateTime = "now";
    });

    _applyTimeRange();
  }

  void _applyTimeRange() {
    String fromTime = _selectedFromDateTime != "Select From Date & Time"
        ? _selectedFromDateTime
        : "";
    String toTime = _selectedToDateTime != "Select To Date & Time"
        ? _selectedToDateTime
        : "";

    String newUrl;
    if (fromTime.isEmpty || toTime.isEmpty) {
      newUrl = _baseUrl;
    } else {
      newUrl = '$_baseUrl&from=$fromTime&to=$toTime';
    }

    String iframeHtml = '''
    <html>
      <body style="margin:0;padding:0;">
        <iframe src="$newUrl" style="border:none;" width="100%" height="100%"></iframe>
      </body>
    </html>
  ''';

    _webViewController.loadUrl(Uri.dataFromString(iframeHtml, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text('device 1'),
          ],
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: <Widget>[
              if (orientation == Orientation.portrait) ...[
                SizedBox(height: 16.0),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
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
              ],
              Expanded(
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _webViewController = webViewController;

                    _webViewController.loadUrl(Uri.dataFromString('''
                    <html>
                      <body style="margin:0;padding:0;">
                        <iframe src="$_baseUrl" style="border:none;" width="100%" height="100%"></iframe>
                      </body>
                    </html>
                    ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DateTimeRangePickerExample(),
  ));
}
