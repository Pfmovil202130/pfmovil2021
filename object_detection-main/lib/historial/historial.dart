import 'package:flutter/material.dart';
import 'package:object_detection/realtime/camera.dart';

void main() => runApp(HistoryApp());

class HistoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Historial de Escaneadas')),
        body: History(),
      ),
    );
  }
}

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(),
          subtitle: Text(CameraFeed.history[index].descripcion),
          leading: Icon(Icons.supervised_user_circle),
        );
      },
      itemCount: history.length,
    );
  }
}
