import 'package:flutter/material.dart';
import 'package:seven_guis/pages/temperature_converter.dart';

import 'pages/crud.dart';
import 'pages/flight_booker.dart';
import 'pages/main.dart';
import 'pages/counter.dart';
import 'pages/timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '7GUIs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (_) => MainPage(),
        '/counter': (_) => CounterPage(),
        '/temperature_converter': (_) => TemperatureConverterPage(),
        '/flight_booker': (_) => FlightBookerPage(),
        '/timer': (_) => TimerPage(),
        '/crud': (_) => CrudPage(),
      },
    );
  }
}

