import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class CameraFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final FlutterTts flutterTts = FlutterTts();
  // The cameraFeed Class takes the cameras list and the setRecognitions
  // function as argument
  CameraFeed(this.cameras, this.setRecognitions);

  @override
  _CameraFeedState createState() => new _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    print(widget.cameras);
    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No Cameras Found.');
    } else {
      controller = new CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;
            Tflite.detectObjectOnFrame(
              bytesList: img.planes.map((plane) {
                return plane.bytes;
              }).toList(),
              model: "SSDMobileNet",
              imageHeight: img.height,
              imageWidth: img.width,
              imageMean: 127.5,
              imageStd: 127.5,
              numResultsPerClass: 1,
              threshold: 0.4,
            ).then((recognitions) {
              /*
              When setRecognitions is called here, the parameters are being passed on to the parent widget as callback. i.e. to the LiveFeed class
               */
              if (recognitions.isNotEmpty) {
                print("Reconocer:");
                printArray(objetos(recognitions));
              }
              widget.setRecognitions(recognitions, img.height, img.width);
              isDetecting = false;
            });
          }
        });
      });
    }
  }

  List<String> objetos(List<dynamic> recog) {
    dynamic a;
    List<String> array = [];
    for (var i = 0; i < recog.length; i++) {
      a = recog.elementAt(i).toString().split(" ");
      if (a != null) {
        print("Validar");
        print(a);
        print(a[10]);
        print(a[12]);
        if (validar(a[10].toString())) {
          array.add(reconocer(a[12].toString()));
        }
      }
    }
    return array;
  }

  void printArray(List<String> array) {
    for (var i = 0; i < array.length; i++) {
      print("1");
      hablar(array.elementAt(i));
      print(array.elementAt(i));
    }
  }

  Future hablar(String a) async {
    print("2");
    await widget.flutterTts.speak(a);
  }

  bool validar(String a) {
    List<String> b = a.split("");
    String c = "";
    for (var i = 0; i < b.length; i++) {
      if (!(b[i].contains(","))) {
        c = c + b[i];
      }
    }
    double compare = 0.0;
    try {
      compare = double.parse(c);
    } catch (e) {
      print(c);
    }
    if (compare > 0.7) {
      print("probabilidad");
      return true;
    } else {
      return false;
    }
  }

  String reconocer(String a) {
    List<String> b = a.split("");
    String c = "";
    for (var i = 0; i < b.length; i++) {
      if (!(b[i].contains("}"))) {
        c = c + b[i];
      }
    }
    return c;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
  }
}
