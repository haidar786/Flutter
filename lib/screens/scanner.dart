import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class Scanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350.0,
        height: 350.0,
        child: new QrCamera(
          qrCodeCallback: (code) {
            print(code);
            final snackBar = SnackBar(content: Text(code));
            Scaffold.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}
