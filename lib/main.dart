import 'package:flutter/material.dart';

import 'Models/mainmodels.dart';
import 'Screens/mufta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, canvasColor: Colors.white),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isShowMuftu = false;
  Mufta mufta = Mufta(cables: [], connections: [], name: '');

  @override
  void initState() {
    //mufta.cables = [];
    /*
    mufta.cables.add(
        CableEnd(fibersNumber: 8, direction: 'Федько/Лукачева', sideIndex: 0));
    mufta.cables
        .add(CableEnd(fibersNumber: 8, direction: 'Школа 15', sideIndex: 1));
    mufta.cables.add(
        CableEnd(fibersNumber: 12, direction: 'Поликлиника', sideIndex: 0));
    //mufta.connections = [];
    mufta.connections.add(Connection(
        cableIndex1: 0, fiberNumber1: 0, cableIndex2: 1, fiberNumber2: 0));
    mufta.connections.add(Connection(
        cableIndex1: 0, fiberNumber1: 1, cableIndex2: 1, fiberNumber2: 1));
    mufta.connections.add(Connection(
        cableIndex1: 1, fiberNumber1: 1, cableIndex2: 1, fiberNumber2: 6));
    */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text(widget.title),),
      body: isShowMuftu
          ? MuftaScreen(
              mufta: mufta,
              callback: () {
                print('recieved callback');
                setState(() {
                  isShowMuftu = false;
                });
              },
            )
          : Column(
              children: [
                TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isShowMuftu = true;
                      });
                    },
                    icon: const Icon(Icons.create_outlined),
                    label: const Text('Create')),
                TextButton.icon(
                    onPressed: () {
                      List<String> localStored = [];
                      String selectedName = '';
                      loadNames().then((value) {
                        setState(() {
                          localStored = value;
                        });
                      });
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              //String muftaName = '';
                              return AlertDialog(
                                title: const Text('Importing'),
                                content: Column(
                                  children: [
                                    const Text('From Local:'),
                                    localStored.isNotEmpty
                                        ? Row(
                                            children: [
                                              DropdownButton<String>(
                                                  value: selectedName == ''
                                                      ? null
                                                      : selectedName,
                                                  items: localStored
                                                      .map((e) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            child: Text(e),
                                                            value: e,
                                                          ))
                                                      .toList(),
                                                  onChanged: (String? variant) {
                                                    print(
                                                        'selection - $variant');
                                                    setState(() {
                                                      selectedName = variant!;
                                                    });
                                                  }),
                                              OutlinedButton(
                                                  onPressed: () {
                                                    print('selected:');
                                                    print(selectedName);
                                                    loadMuftaJson(selectedName)
                                                        .then((value) {
                                                      mufta =
                                                          muftaFromJson(value);
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: const Text('Import'))
                                            ],
                                          )
                                        : const Text('nothing stored'),
                                    const Text('From REST:')
                                  ],
                                ),
                                actions: [
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'))
                                ],
                              );
                            });
                          }).then((value) => setState(() {
                            isShowMuftu = true;
                          }));
                    },
                    icon: const Icon(Icons.import_export_outlined),
                    label: const Text('Import')),
              ],
            ),
    );
  }
}
