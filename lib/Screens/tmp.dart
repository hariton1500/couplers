/*
                    Column(
                      children: List.generate(
                          widget.mufta.cables[isCableSelected!].fibersNumber,
                          (index) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Draggable<int>(
                                  childWhenDragging: Container(
                                    width: 20,
                                    height: 20,
                                    color: widget.mufta.colors[index],
                                  ),
                                  feedback: Container(
                                      width: 10,
                                      height: 10,
                                      child: Text('<${index + 1}>')),
                                  data: index,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    color: widget.mufta.colors[index],
                                    child: Center(
                                        child: Text((index + 1).toString())),
                                  ),
                                ),
                              )),
                    ),
                    Column(
                      children: List.generate(
                          widget.mufta.cables[isCableSelected!].fibersNumber,
                          (index) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DragTarget<int>(
                                  onWillAccept: (data) => true,
                                  onAccept: (data) {
                                    print('$data <---> $index');
                                    setState(() {
                                      widget.mufta.connections.add(Connection(cableIndex1: isCableSelected!, fiberNumber1: data, cableIndex2: , fiberNumber2: index));
                                    });
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    return Container(
                                      width: 20,
                                      height: 20,
                                      color: widget.mufta.colors[index],
                                      child: Center(
                                          child: Text((index + 1).toString())),
                                    );
                                  },
                                ),
                              )),
                    ),
*/