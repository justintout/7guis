import 'dart:async';

import 'package:flutter/material.dart';


class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  final title = "Timer";
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {

  Stopwatch timer;
  Timer updateTimer;
  num initialMax = 15;
  num max;
  

  @override
  void initState() { 
    super.initState();
    max = initialMax;
    timer = Stopwatch()
      ..start();
  }

  @override
  void dispose() {
    updateTimer.cancel();
    timer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateTimer = Timer.periodic(Duration(milliseconds: 100), (_) {
      if (timer.elapsed.inSeconds >= 30) {
        timer.stop();
      }
      if (timer.elapsed.inSeconds >= max) {
        timer.stop();
      }
      if (updateTimer.isActive) setState(() {});
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Text("Elapsed Time:"),
                  Flexible(
                    child: LinearProgressIndicator(
                      value: (timer.elapsedMilliseconds / 1000) / max
                    ),
                  ),
                ]
              ),
              Text("${(timer.elapsedMilliseconds/1000).toStringAsFixed(1)}"),
              Row(
                children: [
                  Text("Duraton:"),
                  Flexible(
                      child: Slider(
                      min: 0.0,
                      max: 30.0,
                      value: max,
                      onChanged: (v) {
                        setState(() {
                          max = v;
                          if (timer.elapsed.inSeconds >= max) {
                            timer.stop();
                          } else if (timer.elapsed.inSeconds < max) {
                            timer.start();
                          }
                        });
                      },
                    ),
                  )
                ]
              ),
              ElevatedButton(
                child: Text("Reset"),
                onPressed: () {
                  timer.reset();
                  timer.start();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
