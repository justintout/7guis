import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  final title = "7GUIs";
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.plus_one),
              label: Text("Counter"),
              onPressed: () => Navigator.pushNamed(context, '/counter'),
            ),
            FlatButton.icon(
              icon: Icon(MdiIcons.thermometer),
              label: Text("Temperature Converter"),
              onPressed: () => Navigator.pushNamed(context, '/temperature_converter'),
            ),
            FlatButton.icon(
              icon: Icon(Icons.flight_takeoff),
              label: Text("Flight Booker"),
              onPressed: () => Navigator.pushNamed(context, '/flight_booker')
            ),
            FlatButton.icon(
              icon: Icon(Icons.timer),
              label: Text("Timer"),
              onPressed: () => Navigator.pushNamed(context, '/timer'),
            ),
            FlatButton.icon(
              icon: Icon(MdiIcons.databasePlus),
              label: Text("CRUD"),
              onPressed: () => Navigator.pushNamed(context, '/crud'),
            ),
            FlatButton.icon(
              icon: Icon(MdiIcons.circleEditOutline),
              label: Text("Circle Drawer"),
              onPressed: () => Navigator.pushNamed(context, '/circle_drawer'),
            ),
            FlatButton.icon(
              icon: Icon(MdiIcons.googleSpreadsheet),
              label: Text("Cells"),
              onPressed: () => Navigator.pushNamed(context, '/cells')
            ),
            Spacer(),
            InkWell(
              child: Text("7GUIs Homepage"),
              onTap: _openHomepage
            )
          ],
        ),
      ),
    );
  }
}

_openHomepage() async {
  const url = "https://eugenkiss.github.io/7guis/";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "failed to open $url";
  }
}