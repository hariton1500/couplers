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
  bool isShowMuftu = true;
  Mufta mufta = Mufta();

  @override
  void initState() {
    //mufta.cables = [];
    mufta.cables!.add(
        CableEnd(fibersNumber: 8, direction: 'Федько/Лукачева', sideIndex: 0));
    mufta.cables!
        .add(CableEnd(fibersNumber: 8, direction: 'Школа 15', sideIndex: 1));
    mufta.cables!.add(
        CableEnd(fibersNumber: 12, direction: 'Поликлиника', sideIndex: 0));
    //mufta.connections = [];
    mufta.connections!.add(Connection(
        cableIndex1: 0, fiberNumber1: 0, cableIndex2: 1, fiberNumber2: 0));
    mufta.connections!.add(Connection(
        cableIndex1: 0, fiberNumber1: 1, cableIndex2: 1, fiberNumber2: 1));
    mufta.connections!.add(Connection(
        cableIndex1: 1, fiberNumber1: 1, cableIndex2: 1, fiberNumber2: 6));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text(widget.title),),
      body: isShowMuftu ? MuftaScreen(mufta: mufta) : Container(),
    );
  }
}
