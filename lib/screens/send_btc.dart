import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
//import 'package:emrals/state_container.dart';
import 'package:flutter/services.dart';
//import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/utils/qr.dart';
import 'package:http/http.dart' as http;
import 'package:emrals/state_container.dart';
import 'dart:convert';

class SendBTCScreen extends StatefulWidget {
  final int emralsAmount;

  SendBTCScreen({Key key, this.emralsAmount}) : super(key: key);

  @override
  _SendBTCScreenState createState() => _SendBTCScreenState();
}

class _SendBTCScreenState extends State<SendBTCScreen> {
  final TextEditingController walletAddressController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String bitcoinAddress = '';
  String newemralsAmount = '';
  String bitcoinAmount = '';
  QrImage qrImageOne;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (bitcoinAddress == '') {
      Map<String, String> headers = {
        "Authorization":
            "token " + StateContainer.of(context).loggedInUser.token,
      };
      http.post(apiUrl + "/payment/", headers: headers, body: {
        'emrals_amount': widget.emralsAmount.toString(),
      }).then((result) {
        var resultJson = json.decode(result.body);
        setState(() {
          bitcoinAddress = resultJson['bitcoin_address'];
          newemralsAmount = resultJson['emrals_amount'];
          bitcoinAmount = resultJson['bitcoin_amount'];
          qrImageOne = QrImage(
            data: bitcoinAddress,
            size: 300,
          );
        });
      });
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Buy Emrals'),
      ),
      body: Form(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Text(
              "Buying " + newemralsAmount + " EMRALS",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Send " + bitcoinAmount + " BTC to address:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            new GestureDetector(
              child: Row(
                children: <Widget>[
                  Text(
                    bitcoinAddress,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.content_copy,
                    color: Colors.black,
                  ),
                ],
              ),
              onTap: () {
                Clipboard.setData(
                  new ClipboardData(text: bitcoinAddress),
                );
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text("Copied to Clipboard"),
                ));
              },
            ),
            SizedBox(height: 10),
            qrImageOne,
            SizedBox(height: 10),
            Text(
              newemralsAmount +
                  " EMRALS will be added to your balance after 1 blockchain confirmation. This usually takes 10 - 30 minutes. You will get an email when the purchase is complete.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "BTC Address: \nBalance: 0 | Confirmations: 0",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
