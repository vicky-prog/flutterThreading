import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

import 'download_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const DownloadExample(),
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
  // ignore: prefer_typing_uninitialized_variables
  var isolate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      test();
                      //createSimpleIsolate();
                    },
                    child: const Text("Run Simple Isolate")),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: const Text("Resume"),
                  onPressed: () {
                    isolate.resume();
                  },
                ),
                ElevatedButton(
                  child: const Text("Pause"),
                  onPressed: () {
                    isolate.pause();
                  },
                ),
                ElevatedButton(
                  child: const Text("Stop"),
                  onPressed: () {
                    isolate.kill(priority: Isolate.immediate);
                  },
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  for (var i = 0; i < 100000000000000000; i++) {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        _counter = i;
                      });
                    });
                  }
                },
                child: Text("Test"))
          ],
        ),
      ),
    );
  }

  test() async {
    var port = ReceivePort();
    isolate = await FlutterIsolate.spawn(heavyTask2, port.sendPort);
    port.listen((msg) {
      print("Received message from isolate $msg");
      setState(() {
        _counter = msg;
      });
    });
  }

  createSimpleIsolate() async {
    final ReceivePort receivePort = ReceivePort();
    isolate = await Isolate.spawn(heavyTask, receivePort.sendPort);
    receivePort.listen((message) {
      setState(() {
        _counter = message;
      });
    });
  }

  static void heavyTask(SendPort sendPort) async {
    for (var i = 0; i < 100000000000; i++) {
      await Future.delayed(const Duration(milliseconds: 500), () {
        sendPort.send(i);
      });
    }
  }
}

void heavyTask2(SendPort sendPort) async {
  for (var i = 0; i < 100000000000; i++) {
    await Future.delayed(const Duration(milliseconds: 500), () {
      sendPort.send(i);
    });
  }
}
