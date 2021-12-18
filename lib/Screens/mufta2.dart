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
    return Stack(children: [
      if (widget.mufta.cables.isNotEmpty)
        ...widget.mufta.cables
            .map((cable) => Positioned(
                left: (widget.mufta.cables.indexOf(cable) + 1) * 50,
                top: 30,
                child: cable.widget(widget.mufta.colors)))
            .toList(),
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
    ]);
  }
}
