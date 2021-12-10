// ignore_for_file: unused_local_variable

import 'package:couplers/Models/mainmodels.dart';
import 'package:flutter/material.dart';

class MuftaScreen extends StatefulWidget {
  const MuftaScreen({Key? key, required this.mufta}) : super(key: key);
  final Mufta mufta;

  @override
  _MuftaScreenState createState() => _MuftaScreenState();
}

class _MuftaScreenState extends State<MuftaScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        CustomPaint(
          //size: 500,
          painter:
              MuftaPainter(widget.mufta, MediaQuery.of(context).size.width),
        )
      ],
    );
  }
}

class MuftaPainter extends CustomPainter {
  final Mufta mufta;
  final double width;
  MuftaPainter(this.mufta, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    //paint.color = Colors.black;
    paint.strokeWidth = 2;
    double wd = width - 60;
    double st = 50;
    const textStyle = TextStyle(color: Colors.black, fontSize: 10);

    double yPos0 = 0, yPos1 = 0;
    for (var cable in mufta.cables!) {
      for (var i = 0; i < cable.fibersNumber; i++) {
        var tp = TextPainter(
            text: TextSpan(text: '${i + 1}', style: textStyle),
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
                (wd - st + 10) / 2,
                (cable2.fiberPosY[fiberNumber2]! -
                        cable1.fiberPosY[fiberNumber1]!) /
                    2),
            paint);
        canvas.drawLine(
            Offset(
                (wd - st + 10) / 2,
                (cable2.fiberPosY[fiberNumber2]! -
                        cable1.fiberPosY[fiberNumber1]!) /
                    2),
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
