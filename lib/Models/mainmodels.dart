import 'package:flutter/material.dart';

class CableEnd {
  int sideIndex;
  String direction;
  int fibersNumber;
  Map<int, double> fiberPosY = {};
  CableEnd(
      {required this.fibersNumber,
      required this.direction,
      required this.sideIndex});
  Map<String, dynamic> toJson() => {
    'direction' : direction,
    'sideIndex' : sideIndex,
    'fibersNumber' : fibersNumber,
    'fiberPosY' : fiberPosY
  };
}

class Connection {
  //List<int> connectionData = [];
  int cableIndex1, fiberNumber1, cableIndex2, fiberNumber2;
  Connection(
      {required this.cableIndex1,
      required this.fiberNumber1,
      required this.cableIndex2,
      required this.fiberNumber2}) {
    //connectionData = [cableIndex1, fiberNumber1, cableIndex2, fiberNumber2];
  }
  Map<String, dynamic> toJson() => {
    //'connectionData' : connectionData,
    'cableIndex1' : cableIndex1,
    'cableIndex2' : cableIndex2,
    'fiberNumber1' : fiberNumber1,
    'fiberNumber2' : fiberNumber2
  };
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
    Colors.brown,
    Colors.grey,
    Colors.white,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.purple,
    Colors.pink,
    Colors.indigo
  ];
  String name = '';
  List<CableEnd>? cables;
  List<Connection>? connections;
  Mufta() {
    cables = [];
    connections = [];
  }
  Map<String, dynamic> toJson() => {
    //'colors' : colors,
    'name' : name,
    'cables' : cables,
    'connections' : connections
  };
}
