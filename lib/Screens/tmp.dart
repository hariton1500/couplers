/*Column(
                  children: List.generate(
                      widget.mufta.connections!
                          .where((connection) => (connection
                                      .connectionData[0] ==
                                  isCableSelected ||
                              connection.connectionData[2] == isCableSelected))
                          .length,
                      (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  '${widget.mufta.cables![widget.mufta.connections![index].connectionData[0]].direction}[${widget.mufta.connections![index].connectionData[1] + 1}] <---> ${widget.mufta.cables![widget.mufta.connections![index].connectionData[2]].direction}[${widget.mufta.connections![index].connectionData[3] + 1}]'),
                              TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      widget.mufta.connections!.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Delete'))
                            ],
                          )))
                          */