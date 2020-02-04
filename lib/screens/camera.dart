import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:emrals/localizations.dart';
import 'package:emrals/state_container.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/report.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:emrals/styles.dart';
import 'dart:convert';
import 'package:emrals/models/offline_report.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class ReportScreen extends StatefulWidget {
  final Report report;
  ReportScreen({Key key, this.report}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  BuildContext _ctx;
  List<CameraDescription> cameras;
  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  String imagePath;
  bool _isReady = false;
  bool _isLoading = false;
  LocationData currentLocation;
  String userToken;
  bool isLocationEnabled;
  var location = Location();

  Future<void> _setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
      isLocationEnabled = await location.serviceEnabled();
      if (!isLocationEnabled) {
        isLocationEnabled = await location.requestService();
      }
      if (isLocationEnabled) {
        try {
          currentLocation = await location.getLocation();
        } on PlatformException catch (locationErr) {
          showInSnackBar(locationErr.details);
        } catch (PlatformException) {
          currentLocation = null;
        }
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
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appLocalization = AppLocalizations.of(context);
    userToken = StateContainer.of(context).loggedInUser.token;
    _ctx = context;
    if (!_isReady) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.report != null
          ? AppBar(
              title: Text(_appLocalization.cleanUpReport+' #' + widget.report.id.toString()),
            )
          : null,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: _cameraPreviewWidget(),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
                  ? (){
                onTakePictureButtonPressed(_appLocalization);
              }
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
      showInSnackBar(AppLocalizations.of(_ctx).error+': '+AppLocalizations.of(_ctx).selectCameraFirst);
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
    showInSnackBar(AppLocalizations.of(_ctx).error+': ${e.code}\n${e.description}');
  }

  Future getLocation() async {
    currentLocation = await location.getLocation();
  }

  void onTakePictureButtonPressed(AppLocalizations appLocalization) {
    _isLoading = true;
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          getLocation();
          upload(File(filePath));
        });
      }
    });
  }

  upload(File imageFile) async {
    if (currentLocation != null) {
      File compressedFile = await FlutterNativeImage.compressImage(
          imageFile.path,
          quality: 80,
          percentage: 80);

      var stream =
          http.ByteStream(DelegatingStream.typed(compressedFile.openRead()));
      var length = await compressedFile.length();

      var uri = Uri.parse(apiUrl + "/upload/");

      var request = http.MultipartRequest("POST", uri);
      request.fields['longitude'] = currentLocation.longitude.toString();
      request.fields['latitude'] = currentLocation.latitude.toString();
      if (widget.report != null) {
        request.fields['report_id'] = widget.report.id.toString();
      }

      var report = OfflineReport(
        imagePath,
        currentLocation.latitude,
        currentLocation.longitude,
      );

      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: basename(compressedFile.path),
      );
      Map<String, String> headers = {"Authorization": "token " + userToken};

      request.headers.addAll(headers);
      request.files.add(multipartFile);

      try {
        var response = await request.send();
        response.stream.transform(utf8.decoder).listen((value) {
          _isLoading = false;
          showDialog(
              context: _ctx,
              builder: (ctx) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(value),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(AppLocalizations.of(_ctx).goToActivity), //check if _ctx context works
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(_ctx, '/home', ModalRoute.withName('/'));
                      },
                    ),
                  ],
                );
              });
        });
      } catch (e) {
        await DatabaseHelper().saveOfflineReport(report);
        await Navigator.pushNamed(_ctx, '/uploads');
      }
    } else {
      showInSnackBar(AppLocalizations.of(_ctx).pleaseEnterValidAmountGreaterThan100);
      _isLoading = false;
    }
  }
}
