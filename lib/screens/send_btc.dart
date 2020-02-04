import 'package:emrals/localizations.dart';
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
    final _appLocalization = AppLocalizations.of(context);
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
        title: Text(_appLocalization.buyEmrals),
      ),
      body: Form(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Text(
              _appLocalization.buying+" " + newemralsAmount + " "+_appLocalization.emrals,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              _appLocalization.send+" " + bitcoinAmount + " "+_appLocalization.btcToAddress+":",
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
                  content: new Text(_appLocalization.copiedToClipBoard),
                ));
              },
            ),
            SizedBox(height: 10),
            qrImageOne,
            SizedBox(height: 10),
            Text(
              newemralsAmount +
                  " "+_appLocalization.emralsToBeAdded,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              _appLocalization.btcAddress+": \n"+_appLocalization.balance+": 0 | "+_appLocalization.confirmation+": 0",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
