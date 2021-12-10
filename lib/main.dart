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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  int _counter = 0;
  bool isShowMuftu = true;
  Mufta mufta = Mufta();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    //mufta.cables = [];
    mufta.cables!.add(CableEnd(fibersNumber: 8, direction: 'Федько/Лукачева', sideIndex: 0));
    mufta.cables!.add(CableEnd(fibersNumber: 16, direction: 'Школа 15', sideIndex: 1));
    //mufta.connections = [];
    mufta.connections!.add(Connection(cableIndex1: 0, fiberNumber1: 1, cableIndex2: 1, fiberNumber2: 1));
    mufta.connections!.add(Connection(cableIndex1: 0, fiberNumber1: 2, cableIndex2: 1, fiberNumber2: 2));
    mufta.connections!.add(Connection(cableIndex1: 0, fiberNumber1: 3, cableIndex2: 1, fiberNumber2: 8));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isShowMuftu ? MuftaScreen(mufta: mufta) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
