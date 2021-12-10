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
    paint.color = Colors.black;
    paint.strokeWidth = 2;
    double wd = width - 60;
    double st = 50;

    for (var cable in mufta.cables!) {
      for (var i = 0; i < cable.fibersNumber; i++) {
        canvas.drawLine(Offset(cable.sideIndex == 0 ? st : wd, i * 11),
            Offset(cable.sideIndex == 0 ? st + 10 : wd + 10, i * 11), paint);
      }
    }

    for (var i = 0; i < mufta.connections!.length; i++) {
      List<String> conList = mufta.connections![i].connection.split(' ');

      int cableIndex1 = int.parse(conList[0]);
      int cableIndex2 = int.parse(conList[2]);
      int fiberNumber1 = int.parse(conList[1]);
      int fiberNumber2 = int.parse(conList[3]);

      int pos0 = 0;
      for (var c = 0; c < cableIndex1; c++) {
        if (mufta.cables![c].sideIndex == 0) {
          pos0 += mufta.cables![c].fibersNumber * 11;
          pos0 += 20;
        }
      }
      pos0 += fiberNumber1 * 11;

      int pos1 = 0;
      for (var c = 0; c < cableIndex2; c++) {
        if (mufta.cables![c].sideIndex == 1) {
          pos1 += mufta.cables![c].fibersNumber * 11;
          pos1 += 20;
        }
      }
      pos1 += fiberNumber2 * 11;

      canvas.drawLine(
          Offset(mufta.cables![cableIndex1].sideIndex == 0 ? st + 10 : wd,
              pos0.toDouble()),
          Offset(mufta.cables![cableIndex2].sideIndex == 0 ? st + 10 : wd,
              pos1.toDouble()),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint

    return true;
    throw UnimplementedError();
  }
}
