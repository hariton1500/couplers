import 'package:flutter/material.dart';

class CableEnd {
  final int sideIndex;
  final String direction;
  final int fibersNumber;
  Map<int, double> fiberPosY = {};
  CableEnd(
      {required this.fibersNumber,
      required this.direction,
      required this.sideIndex});
}

class Connection {
  List<int> connectionData = [];
  Connection(
      {required int cableIndex1,
      required int fiberNumber1,
      required int cableIndex2,
      required int fiberNumber2}) {
    connectionData = [cableIndex1, fiberNumber1, cableIndex2, fiberNumber2];
  }
}

class Mufta {
  List<Color> colors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.brown,
    Colors.grey,
    Colors.white,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.brown
  ];
  String? name;
  List<CableEnd>? cables;
  List<Connection>? connections;
  Mufta() {
    cables = [];
    connections = [];
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
