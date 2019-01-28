import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';



void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class CameraApp extends StatefulWidget {
  
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  List<CameraDescription> cameras;
  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  String imagePath;
   bool _isReady = false;

  Future<void> _setupCameras() async {
    try {
      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      controller = new CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
    } on CameraException catch (e) {
       _showCameraException(e);
    }
    if (!mounted) { return; }
    setState(() {
      _isReady = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _setupCameras();
    // print('camera');
    // super.initState();
    // print('camera1');
    // controller = CameraController(cameras[0], ResolutionPreset.medium);
    // print('camera2');
    // controller.initialize().then((_) {
    //   print('camera3');
    //   if (!mounted) {
    //     return;
    //   }
    //   setState(() {});
    // });
    // print('camera inited');
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (!_isReady) return new Container();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Camera example'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
        ],
      ),
       bottomNavigationBar: BottomNavigationBar(
       currentIndex: 1,
       onTap: (index) { 
         final routes = ["/home", "/camera",'/stats'];
         print(routes[index]);
         Navigator.of(context).pushNamedAndRemoveUntil(routes[index], (route) => false);
       
       },
       fixedColor: Colors.red, // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(icon: new Icon(Icons.home),title: new Text('Home')),
         BottomNavigationBarItem(icon: new Icon(Icons.camera),title: new Text('Camera')),
         //BottomNavigationBarItem(icon: new Icon(Icons.access_alarm),title: new Text('sdf')),
         BottomNavigationBarItem(icon: new Icon(Icons.person),title: new Text('Profile'))
       ],
     ),
    );
  }
  // Widget build(BuildContext context) {
  //   print('camera widget');
  //   if (!controller.value.isInitialized) {
  //     return Container();
  //   }
  //   return AspectRatio(
  //       aspectRatio:
  //       controller.value.aspectRatio,
  //       child: CameraPreview(controller));
  // }
    Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        )
      ],
    );
  }
  
  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

    Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          //videoController?.dispose();
          //videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

}



