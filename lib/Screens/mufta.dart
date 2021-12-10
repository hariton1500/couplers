import 'package:couplers/Models/mainmodels.dart';
import 'package:flutter/material.dart';

class MuftaScreen extends StatefulWidget {
  const MuftaScreen({ Key? key, required this.mufta }) : super(key: key);
  final Mufta mufta;

  @override
  _MuftaScreenState createState() => _MuftaScreenState();
}

class _MuftaScreenState extends State<MuftaScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size.infinite,
          painter: MuftaPainter(widget.mufta),
        )
      ],
    );
  }
}

class MuftaPainter extends CustomPainter {
  final Mufta mufta;
  MuftaPainter(this.mufta);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.red;
    // TODO: implement paint
    for (var i = 0; i < mufta.cables!.length; i++) {
      for (var j = 0; i < mufta.cables![i].fibersNumber; i++) {
        canvas.drawLine(Offset(mufta.cables![i].sideIndex == 0 ? 10 : 500, j * 10), Offset(mufta.cables![i].sideIndex == 0 ? 20 : 510, j * 10), paint);
      }
    }
    for (var i = 0; i < mufta.connections!.length; i++) {
      
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    
    return true;
    throw UnimplementedError();
  }
  
}