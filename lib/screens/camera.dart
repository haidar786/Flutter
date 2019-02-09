import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  BuildContext _ctx;
  List<CameraDescription> cameras;
  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  String imagePath;
  bool _isReady = false;
  bool _isLoading = false;
  String userToken;
  var currentLocation = <String, double>{};

  var location = Location();

  _setuserToken() async {
    User userObject;
    var db = DatabaseHelper();
    userObject = await db.getUser();

    setState(() {
      userToken = userObject.token ?? '';
    });
  }

  Future<void> _setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
      try {
        currentLocation = await location.getLocation();
        print(currentLocation);
      } on PlatformException {
        print('no location available');
        currentLocation = null;
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _isReady = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _setupCameras();
    _setuserToken();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    if (!_isReady) return Container();
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: _cameraPreviewWidget(),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isLoading
          ? CircularProgressIndicator(
              backgroundColor: Colors.red,
            )
          : FloatingActionButton(
              onPressed: controller != null && controller.value.isInitialized
                  ? onTakePictureButtonPressed
                  : null,
              child: Icon(Icons.camera_alt),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _cameraPreviewWidget() {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
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
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Future getLocaion() async {
    currentLocation = await location.getLocation();
  }

  void onTakePictureButtonPressed() {
    _isLoading = true;
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          getLocaion();
          upload(File(filePath));
        });
      }
    });
  }

  upload(File imageFile) async {
    if (currentLocation != null) {
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse('https://www.emrals.com/api/upload/');
      //var uri = Uri.parse('http://192.168.0.8:8000/api/upload/');

      var request = http.MultipartRequest("POST", uri);
      request.fields['longitude'] = currentLocation["longitude"].toString();
      request.fields['latitude'] = currentLocation["latitude"].toString();
      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: basename(imageFile.path),
      );

      Map<String, String> headers = {"Authorization": "bearer " + userToken};

      request.headers.addAll(headers);
      request.files.add(multipartFile);

      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        _isLoading = false;
        //showInSnackBar(value);
        Navigator.pushNamed(_ctx, '/home');
      });
    } else {
      showInSnackBar("Please enable GPS");
      _isLoading = false;
    }
  }
}
