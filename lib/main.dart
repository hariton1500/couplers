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
  bool isShowMuftu = false, isShowSetup = false, isShowImport = false;
  Mufta mufta = Mufta(cables: [], connections: [], name: '');
  Settings settings = Settings();
  List<String> localStored = [];
  String selectedName = '';

  @override
  void initState() {
    loadNames().then((value) {
      setState(() {
        localStored = value;
      });
    });
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      setState(() {
                        loadNames().then((value) => localStored = value);
                        isShowImport = !isShowImport;
                      });
                      /*
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
                          }));*/
                    },
                    icon: const Icon(Icons.import_export_outlined),
                    label: const Text('Import')),
                if (isShowImport) ...[
                  Column(
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
                                        .map((e) => DropdownMenuItem<String>(
                                              child: Text(e),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (String? variant) {
                                      print('selection - $variant');
                                      setState(() {
                                        selectedName = variant!;
                                      });
                                    }),
                                OutlinedButton(
                                    onPressed: () {
                                      print('selected:');
                                      print(selectedName);
                                      loadMuftaJson(selectedName).then((value) {
                                        mufta = muftaFromJson(value);
                                        //Navigator.pop(context);
                                      });
                                    },
                                    child: const Text('Import'))
                              ],
                            )
                          : const Text('nothing stored'),
                      const Text('From REST:')
                    ],
                  ),
                ],
                TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isShowSetup = !isShowSetup;
                      });
                    },
                    icon: const Icon(Icons.settings_outlined),
                    label: const Text('Setup')),
                if (isShowSetup) ...[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        //const Text('Settings'),
                        const Text('Load list of couplers URL:'),
                        TextFormField(
                          initialValue: settings.couplersListUrl,
                          onChanged: (value) =>
                              settings.couplersListUrl = value,
                        ),
                        const Text('Load coupler URL:'),
                        TextFormField(
                          initialValue: settings.couplerUrl,
                          onChanged: (value) => settings.couplerUrl = value,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              setState(() {
                                isShowSetup = false;
                              });
                            },
                            icon: const Icon(Icons.arrow_upward_outlined),
                            label: const Text('Hide'))
                      ],
                    ),
                  ),
                ]
              ],
            ),
    );
  }
}
