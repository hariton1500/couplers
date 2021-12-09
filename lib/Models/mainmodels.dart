class CableEnd {
  final String direction;
  final int fibersNumber;
  CableEnd({required this.fibersNumber, required this.direction});
}

class Connection {
  Map<CableEnd, int>? elementsMap;
  final CableEnd cableEndX, cableEndY;
  final int fiberNumberX, fiberNumberY;
  Connection({required this.cableEndX, required this.fiberNumberX, required this.cableEndY, required this.fiberNumberY}) {
    elementsMap![cableEndX] = fiberNumberX;
  }
}

class Mufta {
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