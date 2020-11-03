import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const _defaultDiameter = 50;

class CircleDrawerPage extends StatefulWidget {
  CircleDrawerPage({Key key}) : super(key: key);

  final title = "Circle Drawer";
  @override
  _CircleDrawerPageState createState() => _CircleDrawerPageState();
}

class _CircleDrawerPageState extends State<CircleDrawerPage> {
  
  List<_Circle> circles = [];
  List<_Edit> edits = [];
  int editCursor = -1;
  undo() {
    edits[editCursor].undo();
    editCursor--;
  }
  redo() {
    editCursor++;
    edits[editCursor].redo();
  }
  edit(_Edit e) {
    editCursor++;
    edits.removeRange(editCursor, edits.length);
    edits.add(e);
  }
  addCircle(Offset center) {
    var circle = _Circle(center: center);
    circles.add(circle);
    edit(_Edit(
      () => setState(() {
        circles.remove(circle);
      }),
      () => setState(() {
        circles.add(circle);
      })
    ));
  }
  updateCircle(int index, num oldDiameter, num newDiameter) {
    setState(() {
      circles[index].diameter = newDiameter;
    });
    edit(_Edit(
      () => setState(() {
        circles[index].diameter = oldDiameter;
      }),
      () => setState(() {
        circles[index].diameter = newDiameter;
      })
    ));
  }

  StreamController<Offset> hoverPosition = StreamController<Offset>();
  int hoveredCircleIndex;
  _Circle get hoveredCircle {
    if (hoveredCircleIndex == null) return null;
    return circles[hoveredCircleIndex];
  }

  @override
  void initState() { 
    super.initState();
    hoverPosition.stream.listen((v) {
      int hoverIndex;
      for (var i = 0; i < circles.length; i++) {
        if (_distance(v, circles[i].center) <= circles[i].radius) {
          hoverIndex = i;
        }
      }
      hoveredCircleIndex = hoverIndex;
      setState(() {
        if (hoveredCircle != null) hoveredCircle.filled = true;
        circles.where((c) => c != hoveredCircle && c.filled).forEach((c) => c.filled = false);
      });
    });
  }

  @override
  void dispose() {
    hoverPosition.close();
    super.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Undo"),
                  onPressed: editCursor > -1 
                    ? undo
                    : null
                ),
                ElevatedButton(
                  child: Text("Redo"),
                  onPressed: editCursor < edits.length - 1
                    ? redo
                    : null
                )
              ]
            ),
            Expanded(
              child: MouseRegion(
                onHover: (event) {
                  hoverPosition.add(event.localPosition);
                },
                child: GestureDetector(
                  onTapUp: (details) {
                    if (hoveredCircle != null) {
                      var sc = StreamController<num>();
                      var initial = hoveredCircle.diameter;
                      var last;
                      sc.stream.listen((v) {
                        last = v;
                        setState(() => hoveredCircle.diameter = v);
                      }, onDone: () {
                        if (last != initial) {
                          updateCircle(hoveredCircleIndex, initial, last);
                        }
                      });
                      showDialog(
                        context: context,
                        builder: (context) => _ResizeDialog(hoveredCircle, sc)
                      ).then((_) {
                        sc.close();
                      });
                      return;
                    }
                    setState(() {
                      addCircle(details.localPosition);
                    });
                  },
                  child: ClipRRect(
                    child: CustomPaint(
                      painter: _CirclePainter(circles),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[800]
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class _Circle {
  num diameter;
  bool filled = true;
  Offset center;
  _Circle({ @required this.center, this.diameter = _defaultDiameter});

  num get radius {
    return diameter / 2;
  }

  @override
  String toString() {
    return "$diameter wide circle at $center";
  }
}

class _CirclePainter extends CustomPainter {

  List<_Circle> circles;
  _CirclePainter(this.circles) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = Colors.grey[700]
      ..style = PaintingStyle.stroke;
    final fill = Paint()
      ..color = Colors.grey[500]
      ..style = PaintingStyle.fill;
    circles.forEach((c) {
      canvas.drawCircle(c.center, c.radius, stroke);
      if (c.filled) {
        canvas.drawCircle(c.center, c.radius, fill);
      }
    });
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return true;
  }
} 

class _ResizeDialog extends StatefulWidget {
  _ResizeDialog(this.circle, this.sc, {Key key}) : super(key: key);

  _Circle circle;
  StreamController<num> sc;

  @override
  __ResizeDialogState createState() => __ResizeDialogState();
}

class __ResizeDialogState extends State<_ResizeDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Adjust diameter of circle at (${widget.circle.center.dx}, ${widget.circle.center.dy})"),
      children: [
        Slider(
          min: 0.0,
          max: 1000.0,
          value: widget.circle.diameter,
          onChanged: (v) {
            widget.sc.add(v);
            setState((){
              widget.circle.diameter = v;
            });
          }
        ),
      ],
    );
  }
}

class _Edit {
  void Function() undo;
  void Function() redo;
  _Edit(this.undo, this.redo);
}

num _distance(Offset a, b) {
  return sqrt(pow(a.dx - b.dx, 2).abs() + pow(a.dy - b.dy, 2).abs());
}