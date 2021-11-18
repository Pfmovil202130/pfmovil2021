import 'package:flutter/material.dart';
import 'package:object_detection/main.dart';
import 'package:object_detection/realtime/camera.dart';

void main() => runApp(HistoryApp());

class HistoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Historial de Escaneadas')),
        body: History(item('', '', '')),
      ),
    );
  }
}

class History extends StatefulWidget {
  @override
  item i;
  History(this.i);
  _HistoryState createState() => _HistoryState(i);
}

class _HistoryState extends State<History> {
  item i;
  _HistoryState(this.i);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(i.nombre),
          subtitle: Text(i.descripcion),
          leading: Icon(Icons.supervised_user_circle),
        );
      },
      itemCount: 100,
    );
  }
}
