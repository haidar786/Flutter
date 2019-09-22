import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String result;
    return Container(
      color: darkGrey,
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.shortestSide,
        height: MediaQuery.of(context).size.shortestSide,
        child: QrCamera(
          qrCodeCallback: (code) {
            if (result != code) {
              result = code;
              print(code);
              final snackBar = SnackBar(content: Text(code));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ),
    );
  }
}
