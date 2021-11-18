import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/realtime/live_camera.dart';
import 'package:object_detection/static%20image/static.dart';
import 'package:object_detection/historial/historial.dart';
import 'package:screenshot/screenshot.dart';
import 'package:object_detection/historial/historial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  // initialize the cameras when the app starts
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  // running the app
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyApp();
  _MyAppState createState() => _MyAppState();
}

class item {
  String nombre, descripcion, photo;
  item(this.nombre, this.descripcion, this.photo);
}

class _MyAppState extends State<MyApp> {
  _MyAppState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Object Detector App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: aboutDialog,
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          // padding: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.red)),
                  height: 250,
                  minWidth: 400,
                  color: Color(int.parse("0xFF26C6DA".replaceAll('#', '0xff'))),
                  child: Text("Imagen",
                      style:
                          new TextStyle(fontSize: 65.0, color: Colors.black)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StaticImage(),
                      ),
                    );
                  },
                ),
                //color: Colors.cyan[400],
                height: 245,
                width: 400,
              ),

              Expanded(
                child: Container(
                  width: 100,
                ),
              ),

              Container(
                alignment: Alignment.center,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.red)),
                  height: 250,
                  minWidth: 400,
                  color: Color(int.parse("0xFF26C6DA".replaceAll('#', '0xff'))),
                  child: Text("Real",
                      style:
                          new TextStyle(fontSize: 65.0, color: Colors.black)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveFeed(cameras),
                      ),
                    );
                  },
                ),
                //color: Colors.cyan[400],
                height: 250,
                width: 400,
              ),
              Container(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.red),
                  ),
                  height: 63,
                  minWidth: 100,
                  color: Color(int.parse("0xFF26C6A".replaceAll('#', '0xff'))),
                  child: Text(
                    "Historial",
                    style: new TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HistoryApp()));
                  },
                ),
              ),
              //  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _cargarInit();
    super.initState();
  }

  _cargarInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<item> its = [];
    List<String> temp;
    setState(() {
      int sw = 0;
      int i = 0;
      while (sw == 0) {
        if (prefs.getStringList(i.toString()) == null) {
          sw = 1;
        } else {
          temp = prefs.getStringList(i.toString());
          its[i] = item(temp[0], temp[1], temp[2]);
          temp = [];
        }
        History(its[i]);
      }
    });
  }

  aboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "Object Detector App",
      applicationLegalese: "By Rupak Karki",
      applicationVersion: "1.0",
      children: <Widget>[
        Text("www.rupakkarki.com.np"),
      ],
    );
  }
}
