import 'package:flutter/material.dart';

class DownloadScreen extends StatefulWidget {
  static const String routeName = '/download-screen';

  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Screen'),
      ),
    );
  }
}
