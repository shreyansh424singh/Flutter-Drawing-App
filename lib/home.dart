import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DrawingArea {
  Offset point;
  Paint areaPaint;
  DrawingArea({this.point, this.areaPaint});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DrawingArea> points = [];
  Color selectedColor;
  double strokeWidth;

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  void selectColor() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('color Chooser'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              this.setState(() {
                selectedColor = color;
              });
            },
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('close'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return new Scaffold(
      appBar: AppBar(
        title: Text('draw'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/menu');
          },
          child: Icon(Icons.menu),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(138, 35, 135, 1.0),
                  Color.fromRGBO(233, 64, 87, 1.0),
                  Color.fromRGBO(242, 113, 33, 1.0),
                ])),
          ),
          Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      width: width * 0.9,
                      height: height * 0.76,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                            )
                          ]),
                      child: GestureDetector(
                        onPanDown: (details) {
                          this.setState(() {
                            points.add(DrawingArea(
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = selectedColor
                                  ..strokeWidth = strokeWidth));
                          });
                        },
                        onPanUpdate: (details) {
                          this.setState(() {
                            points.add(DrawingArea(
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = selectedColor
                                  ..strokeWidth = strokeWidth));
                          });
                        },
                        onPanEnd: (details) {
                          this.setState(() {
                            points.add(null);
                          });
                        },
                        child: SizedBox.expand(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            child: CustomPaint(
                                painter: MyCustomPainter(points: points)),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.color_lens,
                              color: selectedColor,
                            ),
                            onPressed: () {
                              selectColor();
                            }),
                        Expanded(
                            child: Slider(
                                min: 1.0,
                                max: 10.0,
                                activeColor: selectedColor,
                                value: strokeWidth,
                                onChanged: (value) {
                                  this.setState(() {
                                    strokeWidth = value;
                                  });
                                })),
                        IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red[900],
                            onPressed: () {
                              this.setState(() {
                                points.clear();
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.save),
                            color: Colors.blue,
                            onPressed: () {})
                      ],
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  List<DrawingArea> points;
  Color color;
  double strokeWidth;

  MyCustomPainter({@required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i].point, points[i + 1].point, points[i].areaPaint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(
            PointMode.points, [points[i].point], points[i].areaPaint);
      }
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) =>
      oldDelegate.points != points;
}
