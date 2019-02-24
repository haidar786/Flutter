import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class Scanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 600.0,
      child: new QrCamera(
        qrCodeCallback: (code) {
          print(code);
        },
      ),
    );
  }
}
