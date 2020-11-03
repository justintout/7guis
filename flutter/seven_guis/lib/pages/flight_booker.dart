import 'dart:html';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class FlightBookerPage extends StatefulWidget {
  FlightBookerPage({Key key}) : super(key: key);

  final title = "Flight Booker";

  final inputDecoration = InputDecoration(
    icon: Icon(Icons.calendar_today),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue
      )
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey
      )
    )
  );
  @override
  _FlightBookerPageState createState() => _FlightBookerPageState();
}

class _FlightBookerPageState extends State<FlightBookerPage> {

  final dropdownItems = ['one-way flight', 'return flight'];
  String dropdownValue = 'one-way flight';
  DateTime initialDate, departDate, returnDate;
  TextEditingController departController = TextEditingController();
  TextEditingController returnController = TextEditingController();

  get enableReturnDate {
    return dropdownValue == 'return flight';
  }

  get enableBookButton {
    return dropdownValue == 'one-way flight' || returnDate.isAfter(departDate);
  }

  get modalText {
    final suffix = dropdownValue == 'one-way flight' 
      ? '.'
      : ' and returning on ${returnController.text}.';
    return "You have booked a $dropdownValue, departing on ${departController.text}" + suffix;
  }

  @override
  @override
  void initState() {
    initialDate = departDate = returnDate = DateTime.now();
    departController.text = _format(departDate);
    returnController.text = _format(returnDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: dropdownValue,
              items: dropdownItems.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) {
                setState(() {
                  dropdownValue = v;
                });
              }
            ),
            TextField(
              controller: departController,
              decoration: widget.inputDecoration,
              onTap: () async {
                final selected = await selectDate(context, initialDate: departDate);
                setState(() {
                  departDate = selected ?? departDate;
                  departController.text = _format(departDate);
                });
              }
            ),
            TextField(
              controller: returnController,
              enabled: enableReturnDate,
              decoration: widget.inputDecoration,
              onTap: () async {
                final selected = await selectDate(context, initialDate: returnDate) ?? departDate;
                setState(() {
                  returnDate = selected ?? returnDate;
                  returnController.text = _format(returnDate);
                });
              },
            ),
            ElevatedButton(
              child: Text("Book"),
              onPressed: enableBookButton
              ? () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                      children: [
                        Text(modalText)
                      ],
                    )
                );
              }
              : null
            ),
          ],
        ),
      ),
    );
  }

  selectDate(BuildContext context, {DateTime initialDate, DateTime firstDate}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime(2030),
    );
    return date;
  }
}

String _format(DateTime d) {
  return DateFormat.yMd().format(d);
}