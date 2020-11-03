import 'package:flutter/material.dart';


class TemperatureConverterPage extends StatefulWidget {
  TemperatureConverterPage({Key key}) : super(key: key);

  final title = "Temperature Converter";
  @override
  _TemperatureConverterPageState createState() => _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  
  TextEditingController _cController = TextEditingController();
  TextEditingController _fController = TextEditingController();

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      maxLines: 1,
                      controller: _cController,
                      onChanged: (v) {
                        if (v == "") {
                          _fController.text = "";
                          return;
                        }
                        num n = num.tryParse(v);
                        if (n != null) {
                          _fController.text = _ctof(n).toString();
                        }
                      }
                    ),
                  ),
                  Text("°C")
                ]
              ),
            ),
            Text("="),
            Flexible(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      maxLines: 1,
                      controller: _fController,
                      onChanged: (v) {
                        if (v == "") {
                          _cController.text = "";
                          return;
                        }
                        num n = num.tryParse(v);
                        if (n != null) {
                          _cController.text = _ftoc(n).toString();
                        }
                      }
                    ),
                  ),
                  Text("°F")
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}

num _ctof(num c) {
  return c * (9/5) + 32;
}

num _ftoc(num f) {
  return (f - 32) * (5/9);
}