import 'package:couplers/Models/mainmodels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MuftaScreen extends StatefulWidget {
  const MuftaScreen({Key? key, required this.mufta, required this.callback})
      : super(key: key);
  final Mufta mufta;
  final Function callback;

  @override
  _MuftaScreenState createState() => _MuftaScreenState();
}

class _MuftaScreenState extends State<MuftaScreen> {
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
    //print('List of connections:');
    //for (var connection in widget.mufta.connections!) {print(connection.connectionData);}
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
          //const SizedBox(height: 30,),
          GestureDetector(
            onTapDown: (details) {
              //print(details.localPosition);
              //print(widget.mufta.cables!.length);
              int index = widget.mufta.cables.indexWhere((cable) {
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
                height: longestSideHeight * 11 + 50,
              ),
              painter: MuftaPainter(widget.mufta,
                  MediaQuery.of(context).size.width, isCableSelected ?? -1),
            ),
          ),
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
                          List<DropdownMenuItem<int>> fibersList =
                              List.generate(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isCableSelected != null && isCableSelected! >= 0
                  ? TextButton.icon(
                      onPressed: () {
                        showDialog<Connection>(
                            context: context,
                            builder: (BuildContext context) {
                              int cableIndex1 = isCableSelected!,
                                  fiberNumber1 = 1,
                                  cableIndex2 = 0,
                                  fiberNumber2 = 1;
                              List<DropdownMenuItem<int>> fibers1 =
                                  List.generate(
                                      widget.mufta.cables[cableIndex1]
                                          .fibersNumber,
                                      (index) => DropdownMenuItem(
                                          value: index + 1,
                                          child: Text((index + 1).toString())));
                              List<DropdownMenuItem<int>> fibers2 =
                                  List.generate(
                                      widget.mufta.cables[cableIndex2]
                                          .fibersNumber,
                                      (index) => DropdownMenuItem(
                                          value: index + 1,
                                          child: Text((index + 1).toString())));
                              //print(fibers2.length);
                              List<DropdownMenuItem<int>> cables =
                                  List.generate(
                                      widget.mufta.cables.length,
                                      (index) => DropdownMenuItem(
                                          value: index,
                                          child: Text(widget
                                              .mufta.cables[index].direction)));
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                //print(cableIndex2);
                                fibers2 = List.generate(
                                    widget
                                        .mufta.cables[cableIndex2].fibersNumber,
                                    (index) => DropdownMenuItem(
                                        value: index + 1,
                                        child: Text((index + 1).toString())));
                                return AlertDialog(
                                  title: const Text('Add connection'),
                                  content: Column(
                                    children: [
                                      const Text('From:'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(widget.mufta.cables[cableIndex1]
                                              .direction),
                                          DropdownButton<int>(
                                            value: fiberNumber1,
                                            items: fibers1,
                                            onChanged: (item) {
                                              setState(() {
                                                fiberNumber1 = item!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const Text('To:'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          DropdownButton<int>(
                                            value: cableIndex2,
                                            items: cables,
                                            onChanged: (item) {
                                              setState(() {
                                                cableIndex2 = item!;
                                              });
                                            },
                                          ),
                                          DropdownButton<int>(
                                            value: fiberNumber2,
                                            items: fibers2,
                                            onChanged: (item) {
                                              setState(() {
                                                fiberNumber2 = item!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
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
                                          Navigator.of(context).pop(Connection(
                                              cableIndex1: cableIndex1,
                                              fiberNumber1: fiberNumber1 - 1,
                                              cableIndex2: cableIndex2,
                                              fiberNumber2: fiberNumber2 - 1));
                                        },
                                        child: const Text('Add'))
                                  ],
                                );
                              });
                            }).then((value) => setState(() {
                              if (value != null) {
                                widget.mufta.connections.add(value);
                              }
                            }));
                      },
                      icon: const Icon(Icons.add_outlined),
                      label: const Text('Add connection'))
                  : Container(),
              isCableSelected != null && isCableSelected! >= 0
                  ? TextButton.icon(
                      onPressed: () {
                        setState(() {
                          isShowAddConnections = !isShowAddConnections;
                        });
                      },
                      icon: const Icon(Icons.add_box_outlined),
                      label: const Text('Add connections'))
                  : Container(),
              widget.mufta.connections.isNotEmpty
                  ? TextButton.icon(
                      icon: const Icon(Icons.delete_forever_outlined),
                      onPressed: () {
                        setState(() {
                          widget.mufta.connections.clear();
                        });
                      },
                      label: const Text('Delete all connections'),
                    )
                  : Container(),
            ],
          ),
          if (isShowAddConnections) ...[
            Column(children: [
              const Text('Add connections'),
              Row(
                children: List.generate(
                    widget.mufta.cables.length,
                    (cableIndex) => Column(
                          children: List.generate(
                              widget.mufta.cables[cableIndex].fibersNumber,
                              (index) => Draggable<CableEnd>(
                                  child: DragTarget<CableEnd>(
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return Container();
                                    },
                                  ),
                                  feedback: Container())),
                        )),
              )
            ])
          ],
          Row(
            children: [
              widget.mufta.cables.isNotEmpty
                  ? TextButton.icon(
                      onPressed: () {
                        var variants = const [
                          'to Local Device',
                          'to REST of billing software'
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                value: e, child: Text(e)))
                            .toList();
                        String exportVariant = variants.first.value!;
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: const Text('Export'),
                                  content: Column(
                                    children: [
                                      DropdownButton<String>(
                                          value: exportVariant,
                                          items: variants,
                                          onChanged: (variant) {
                                            setState(() {
                                              exportVariant = variant!;
                                            });
                                          }),
                                      exportVariant == variants[0].value
                                          ? Text(
                                              'exporting to local device coupler ${widget.mufta.name}')
                                          : Container(),
                                      exportVariant == variants[1].value
                                          ? const Text(
                                              'exporting to REST URL: ')
                                          : Container()
                                    ],
                                  ),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () {
                                          if (exportVariant ==
                                              variants[0].value) {
                                            saveToLocal(widget.mufta);
                                          }
                                          Navigator.of(context)
                                              .pop(exportVariant);
                                        },
                                        child: const Text('Export'))
                                  ],
                                );
                              });
                            }).then((value) => print(value));
                      },
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Export'))
                  : Container(),
              TextButton.icon(
                  onPressed: () {
                    //super.widget.callback;
                    //print('call back');
                    widget.callback();
                  },
                  icon: const Icon(Icons.arrow_back_outlined),
                  label: const Text('Back'))
            ],
          ),
          isCableSelected != null && isCableSelected! >= 0
              ? Column(
                  children: widget.mufta.connections
                      .where((element) =>
                          element.cableIndex1 == isCableSelected ||
                          element.cableIndex2 == isCableSelected)
                      .map((c) => Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 40,
                              ),
                              Text(
                                  '${widget.mufta.cables[c.cableIndex1].direction}[${c.fiberNumber1 + 1}] <---> ${widget.mufta.cables[c.cableIndex2].direction}[${c.fiberNumber2 + 1}]'),
                              TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      widget.mufta.connections.remove(c);
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Delete'))
                            ],
                          ))
                      .toList(),
                )
              : Container(),
        ],
      ),
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

void saveToLocal(Mufta mufta) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(mufta.name, muftaToJson(mufta));
}

Future<List<String>> loadNames() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getKeys().toList();
}

Future<String> loadMuftaJson(String json) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString(json) ?? '';
}
