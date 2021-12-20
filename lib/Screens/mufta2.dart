import 'package:couplers/Models/mainmodels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MuftaScreen2 extends StatefulWidget {
  const MuftaScreen2({Key? key, required this.mufta, required this.callback})
      : super(key: key);
  final Mufta mufta;
  final Function callback;

  @override
  _MuftaScreen2State createState() => _MuftaScreen2State();
}

class _MuftaScreen2State extends State<MuftaScreen2> {
  int? isCableSelected;
  int longestSideHeight = 10;
  bool isShowAddConnections = false;

  @override
  Widget build(BuildContext context) {
    int tmp0 = 0, tmp1 = 0;
    for (var cable in widget.mufta.cables) {
      cable.sideIndex == 0
          ? tmp0 += cable.fibersNumber
          : tmp1 += cable.fibersNumber;
    }
    tmp0 >= tmp1 ? longestSideHeight = tmp0 : longestSideHeight = tmp1;
    List sidePos = [30, 30];
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.topStart,
        children: [
            Positioned(
              left: 0,
              top: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Coupler name:'),
                  TextButton(
                      onPressed: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              String name = '';
                              return AlertDialog(
                                title: const Text('Name editing'),
                                content: TextField(
                                  onChanged: (text) => name = text,
                                ),
                                actions: [
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context, name);
                                      },
                                      child: const Text('Ok'))
                                ],
                              );
                            }).then((value) {
                          setState(() {
                            widget.mufta.name = value ?? '';
                          });
                        });
                      },
                      child: Text(
                          widget.mufta.name == '' ? 'NoName' : widget.mufta.name))
                ],
              ),
            ),
            Positioned(
              top: 50,
              child: CustomPaint(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: longestSideHeight * 16 + 50,
                ),
                painter: MuftaPainter(widget.mufta,
                  MediaQuery.of(context).size.width, isCableSelected ?? -1)
              ),
            ),
            if (widget.mufta.cables.isNotEmpty)
              ...widget.mufta.cables.where((cable) => cable.sideIndex == 0)
                  .map((cable) {
                    return Positioned(
                      left: 50,
                      top: sidePos[0],
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.mufta.cables.indexOf(cable) == isCableSelected ? Colors.redAccent : Colors.white
                          )
                        ),
                        child: cable.widget(widget.mufta.colors)
                      )
                    );
                  })
                  .toList(),
            if (widget.mufta.cables.isNotEmpty)
              ...widget.mufta.cables
                  .map((cable) => Positioned(top: 30, left: 10, child: RotatedBox(quarterTurns: 1, child: TextButton(onPressed: () {setState(() {
                    isCableSelected = widget.mufta.cables.indexOf(cable);
                  });}, child: Text(cable.direction)),))).toList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                    onPressed: () {
                      showDialog<CableEnd>(
                          context: context,
                          builder: (BuildContext context) {
                            String cableName = '';
                            int fibersNumber = 1;
                            List<DropdownMenuItem<int>> fibersList = List.generate(
                                24,
                                (i) => DropdownMenuItem<int>(
                                      value: i + 1,
                                      child: Text((i + 1).toString()),
                                    ));
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: const Text('Adding of cable'),
                                content: Column(
                                  children: [
                                    const Text('Direction:'),
                                    TextField(
                                      keyboardType: TextInputType.text,
                                      onChanged: (text) {
                                        cableName = text;
                                      },
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Number of Fibers:'),
                                    ),
                                    DropdownButton<int>(
                                        value: fibersNumber,
                                        onChanged: (i) {
                                          //print(i);
                                          setState(() {
                                            fibersNumber = i!;
                                          });
                                        },
                                        items: fibersList)
                                    //TextField(keyboardType: TextInputType.number, onChanged: (text) {fibersNumber = int.parse(text);}),
                                  ],
                                ),
                                actions: [
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel')),
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(CableEnd(
                                            direction: cableName,
                                            fibersNumber: fibersNumber,
                                            sideIndex: 0));
                                      },
                                      child: const Text('Add'))
                                ],
                              );
                            });
                          }).then((value) => setState(() {
                            if (value != null) widget.mufta.cables.add(value);
                          }));
                    },
                    icon: const Icon(Icons.add_outlined),
                    label: const Text('Add cable')),
                isCableSelected != null && isCableSelected! >= 0
                    ? TextButton.icon(
                        onPressed: () {
                          setState(() {
                            if (widget.mufta.cables[isCableSelected!].sideIndex ==
                                0) {
                              widget.mufta.cables[isCableSelected!].sideIndex = 1;
                            } else {
                              widget.mufta.cables[isCableSelected!].sideIndex = 0;
                            }
                          });
                          //print(widget.mufta.toJson());
                          //print(jsonEncode(widget.mufta));
                        },
                        icon: const Icon(Icons.change_circle_outlined),
                        label: const Text('Change side'))
                    : Container(),
                isCableSelected != null && isCableSelected! >= 0
                    ? TextButton.icon(
                        onPressed: () {
                          setState(() {
                            widget.mufta.connections.removeWhere((connection) {
                              return (connection.cableIndex1 == isCableSelected ||
                                  connection.cableIndex2 == isCableSelected);
                            });
                            widget.mufta.cables.removeAt(isCableSelected!);
                            isCableSelected = -1;
                          });
                        },
                        icon: const Icon(Icons.remove_outlined),
                        label: const Text('Delete cable'))
                    : Container(),
              ],
            ),
      ]),
    );
  }
}

class MuftaPainter extends CustomPainter {
  final Mufta mufta;
  final double width;
  final int selectedCableIndex;
  MuftaPainter(this.mufta, this.width, this.selectedCableIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.strokeWidth = 2;
    double wd = width - 60;
    double st = 50;

    double yPos0 = 20, yPos1 = 20;
    for (var cable in mufta.cables) {
      var tpDirection = TextPainter(
          text: TextSpan(
              text: cable.direction, style: const TextStyle(fontSize: 10)),
          textDirection: TextDirection.ltr);
      tpDirection.layout();
      if (cable.sideIndex == 0) {
        tpDirection.paint(canvas, Offset(st - 30, yPos0 - 15));
      } else {
        tpDirection.paint(canvas, Offset(wd - 25, yPos1 - 15));
      }
      for (var i = 0; i < cable.fibersNumber; i++) {
        TextStyle ts = const TextStyle(fontSize: 10);
        if (mufta.cables.indexOf(cable) == selectedCableIndex) {
          ts = ts.copyWith(color: Colors.red);
          ts = ts.copyWith(fontWeight: FontWeight.bold);
          //print('printing bold');
        } else {
          ts = ts.copyWith(color: Colors.black);
        }
        var tp = TextPainter(
            text: TextSpan(text: '${i + 1}', style: ts),
            textDirection: TextDirection.ltr);
        tp.layout();
        if (cable.sideIndex == 0) {
          tp.paint(canvas, Offset(st - 12, yPos0 - 5));
        } else {
          tp.paint(canvas, Offset(wd + 17, yPos1 - 5));
        }
        paint.color = mufta.colors[i];
        if (cable.sideIndex == 0) {
          canvas.drawLine(Offset(st, yPos0), Offset(st + 10, yPos0), paint);
          cable.fiberPosY[i] = yPos0;
          yPos0 += 11;
        } else {
          canvas.drawLine(Offset(wd, yPos1), Offset(wd + 10, yPos1), paint);
          cable.fiberPosY[i] = yPos1;
          yPos1 += 11;
        }
      }
      if (cable.sideIndex == 0) {
        yPos0 += 22;
      } else {
        yPos1 += 22;
      }
    }

    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;

    for (var connection in mufta.connections) {
      //List<int> conList = connection.connectionData;

      int cableIndex1 = connection.cableIndex1;
      int cableIndex2 = connection.cableIndex2;
      int fiberNumber1 = connection.fiberNumber1;
      int fiberNumber2 = connection.fiberNumber2;

      CableEnd cable1 = mufta.cables[cableIndex1],
          cable2 = mufta.cables[cableIndex2];
      if (cable1.sideIndex != cable2.sideIndex) {
        canvas.drawLine(
            Offset(cable1.sideIndex == 0 ? st + 10 : wd,
                cable1.fiberPosY[fiberNumber1]!),
            Offset(cable2.sideIndex == 0 ? st + 10 : wd,
                cable2.fiberPosY[fiberNumber2]!),
            paint);
      } else {
        Path path = Path();
        path.moveTo(cable1.sideIndex == 0 ? st + 10 : wd,
            cable1.fiberPosY[fiberNumber1]!);
        path.arcToPoint(
            Offset(cable2.sideIndex == 0 ? st + 10 : wd,
                cable2.fiberPosY[fiberNumber2]!),
            radius: const Radius.elliptical(20, 10),
            clockwise: cable2.sideIndex == 0 &&
                cable1.fiberPosY[fiberNumber1]! <
                    cable2.fiberPosY[fiberNumber2]!);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
