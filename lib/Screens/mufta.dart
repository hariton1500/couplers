import 'package:couplers/Models/mainmodels.dart';
import 'package:flutter/material.dart';

class MuftaScreen extends StatefulWidget {
  const MuftaScreen({Key? key, required this.mufta}) : super(key: key);
  final Mufta mufta;

  @override
  _MuftaScreenState createState() => _MuftaScreenState();
}

class _MuftaScreenState extends State<MuftaScreen> {
  int? isCableSelected;
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTapDown: (details) {
            //print(details.localPosition);
            //print(widget.mufta.cables!.length);
            int index = widget.mufta.cables!.indexWhere((cable) {
              double x = cable.sideIndex == 0
                  ? 50
                  : MediaQuery.of(context).size.width - 60;
              if (details.localPosition.dx >= x - 20 &&
                  details.localPosition.dx <= x + 20 &&
                  details.localPosition.dy >= cable.fiberPosY.values.first &&
                  details.localPosition.dy <= cable.fiberPosY.values.last) {
                return true;
              } else {
                return false;
              }
            });
            //print('taped on cable index = $index');
            setState(() {
              isCableSelected = index;
            });
          },
          child: CustomPaint(
            //size: 500,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - 100,
            ),
            painter: MuftaPainter(widget.mufta,
                MediaQuery.of(context).size.width, isCableSelected ?? -1),
          ),
        ),
        TextButton.icon(onPressed: () {
          showDialog<CableEnd>(context: context, builder: (builContext) {
            String? cableName;
            int fibersNumber = 1;
            List<DropdownMenuItem<int>> fibersList = List.generate(24, (i) => DropdownMenuItem<int>(value: i + 1, child: Text((i + 1).toString()),));
            return AlertDialog(
              title: const Text('Adding of cable'),
              content: Column(
                children: [
                  const Text('Direction:'),
                  TextField(
                    keyboardType: TextInputType.text,
                    onChanged: (text) {cableName = text;},
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Number of Fibers:'),
                  ),
                  DropdownButton<int>(
                    value: fibersNumber,
                    onChanged: (i) {
                      print(i);
                      setState(() {fibersNumber = i!;print(fibersNumber);});},
                    items: fibersList
                  )
                  //TextField(keyboardType: TextInputType.number, onChanged: (text) {fibersNumber = int.parse(text);}),
                ],
              ),
              actions: [
                OutlinedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: const Text('Cancel')),
                OutlinedButton(onPressed: () {Navigator.of(context).pop(CableEnd(direction: cableName!, fibersNumber: fibersNumber, sideIndex: 0));}, child: const Text('Add'))
              ],
            );
          }).then((value) => setState((){
            if (value != null) widget.mufta.cables!.add(value);
          }));
        }, icon: const Icon(Icons.add_outlined), label: const Text('Add cable')),
        widget.mufta.connections!.isNotEmpty
            ? TextButton.icon(
                icon: const Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  setState(() {
                    widget.mufta.connections!.clear();
                  });
                },
                label: const Text('Delete all connections'),
              )
            : Container(),
        isCableSelected != null && isCableSelected! >= 0
            ? TextButton.icon(
                onPressed: () {
                  setState(() {
                    widget.mufta.connections!.removeWhere((connection) {
                      return (connection.connectionData[0] == isCableSelected ||
                          connection.connectionData[2] == isCableSelected);
                    });
                    widget.mufta.cables!.removeAt(isCableSelected!);
                    isCableSelected = -1;
                  });
                },
                icon: const Icon(Icons.remove_outlined),
                label: const Text('Delete cable'))
            : Container(),
        isCableSelected != null && isCableSelected! >= 0
            ? TextButton.icon(
                onPressed: () {
                  setState(() {
                    if (widget.mufta.cables![isCableSelected!].sideIndex == 0) {
                      widget.mufta.cables![isCableSelected!].sideIndex = 1;
                    } else {
                      widget.mufta.cables![isCableSelected!].sideIndex = 0;
                    }
                  });
                },
                icon: const Icon(Icons.change_circle_outlined),
                label: const Text('Change side'))
            : Container(),
        isCableSelected != null && isCableSelected! >= 0
            ? Column(
                children: List.generate(widget.mufta.connections!.where((connection) => (connection.connectionData[0] == isCableSelected || connection.connectionData[2] == isCableSelected)).length, (index) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.mufta.cables![widget.mufta.connections![index].connectionData[0]].direction}[${widget.mufta.connections![index].connectionData[1] + 1}] <---> ${widget.mufta.cables![widget.mufta.connections![index].connectionData[2]].direction}[${widget.mufta.connections![index].connectionData[3] + 1}]'),
                    TextButton.icon(onPressed: () {
                      setState(() {
                        widget.mufta.connections!.removeAt(index);
                      });
                    }, icon: const Icon(Icons.delete_outline), label: const Text('Delete'))
                  ],
                ))
              )
            : Container(),
      ],
    );
  }
}

Widget createConnection(Mufta _mufta) {
  return Column(
    children: [
      Row(
        children: List.generate(_mufta.cables!.length, (index) => Text(_mufta.cables![index].direction)),
      ),
      Row(
        children: List.generate(_mufta.cables!.length, (index) => DropdownButton<String>(
          items: List.generate(_mufta.cables![index].fibersNumber, (index) {
            return DropdownMenuItem<String>(child: Text(index.toString()));
          })
          )),
      )
    ]
  );
}

class MuftaPainter extends CustomPainter {
  final Mufta mufta;
  final double width;
  final int selectedCableIndex;
  MuftaPainter(this.mufta, this.width, this.selectedCableIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    //print(selectedCableIndex);
    //paint.color = Colors.black;
    paint.strokeWidth = 2;
    double wd = width - 60;
    double st = 50;

    double yPos0 = 20, yPos1 = 20;
    for (var cable in mufta.cables!) {
      var tpDirection = TextPainter(
          text: TextSpan(
              text: cable.direction, style: const TextStyle(fontSize: 10)),
          textDirection: TextDirection.ltr);
      //print(cable.direction);
      //canvas.rotate(pi);
      tpDirection.layout();
      if (cable.sideIndex == 0) {
        tpDirection.paint(canvas, Offset(st - 30, yPos0 - 15));
      } else {
        tpDirection.paint(canvas, Offset(wd - 25, yPos1 - 15));
      }
      //canvas.rotate(-pi);
      for (var i = 0; i < cable.fibersNumber; i++) {
        TextStyle ts = const TextStyle(fontSize: 10);
        if (mufta.cables!.indexOf(cable) == selectedCableIndex) {
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
          tp.paint(canvas, Offset(st - 10, yPos0 - 5));
        } else {
          tp.paint(canvas, Offset(wd + 15, yPos1 - 5));
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

    for (var connection in mufta.connections!) {
      List<int> conList = connection.connectionData;

      int cableIndex1 = conList[0];
      int cableIndex2 = conList[2];
      int fiberNumber1 = conList[1];
      int fiberNumber2 = conList[3];

      CableEnd cable1 = mufta.cables![cableIndex1],
          cable2 = mufta.cables![cableIndex2];
      if (cable1.sideIndex != cable2.sideIndex) {
        canvas.drawLine(
            Offset(cable1.sideIndex == 0 ? st + 10 : wd,
                cable1.fiberPosY[fiberNumber1]!),
            Offset(cable2.sideIndex == 0 ? st + 10 : wd,
                cable2.fiberPosY[fiberNumber2]!),
            paint);
      } else {
        canvas.drawLine(
            Offset(cable1.sideIndex == 0 ? st + 10 : wd,
                cable1.fiberPosY[fiberNumber1]!),
            Offset(
                width / 2,
                (cable2.fiberPosY[fiberNumber2]! -
                            cable1.fiberPosY[fiberNumber1]!) /
                        2 +
                    20),
            paint);
        canvas.drawLine(
            Offset(
                width / 2,
                (cable2.fiberPosY[fiberNumber2]! -
                            cable1.fiberPosY[fiberNumber1]!) /
                        2 +
                    20),
            Offset(cable2.sideIndex == 0 ? st + 10 : wd,
                cable2.fiberPosY[fiberNumber2]!),
            paint);
        paint.style = PaintingStyle.stroke;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint

    return true;
    throw UnimplementedError();
  }
}
