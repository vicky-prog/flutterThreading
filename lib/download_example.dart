import 'package:flutter/material.dart';
//vignesh-designcrewz
//vignesh.designcrewz@gmail.com

class DownloadExample extends StatefulWidget {
  const DownloadExample({Key? key}) : super(key: key);

  @override
  State<DownloadExample> createState() => _DownloadExampleState();
}

class _DownloadExampleState extends State<DownloadExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Download example")),
    );
  }
}
