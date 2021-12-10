class CableEnd {
  final int sideIndex;
  final String direction;
  final int fibersNumber;
  CableEnd({required this.fibersNumber, required this.direction, required this.sideIndex});
}

class Connection {
  List<String> connections = [];
  Connection({required int cableIndex1, required int fiberNumber1, required int cableIndex2, required int fiberNumber2}) {
    connections.add('$cableIndex1 $fiberNumber1 $cableIndex2 $fiberNumber2');
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