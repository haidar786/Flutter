import 'package:flutter/material.dart';
import 'package:emrals/state_container.dart';
import 'package:flutter/services.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/utils/qr.dart';

class SendBTCScreen extends StatefulWidget {
  final int emralsAmount;

  SendBTCScreen({Key key, this.emralsAmount}) : super(key: key);

  @override
  _SendBTCScreenState createState() => _SendBTCScreenState();
}

class _SendBTCScreenState extends State<SendBTCScreen> {
  final TextEditingController walletAddressController = TextEditingController();

  // final TextEditingController amountController = TextEditingController();
  // String send_bitcoin = "Send BTC";
  // String old_amount = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //User loggedInUser = StateContainer.of(context).loggedInUser;
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
              "Buying " + widget.emralsAmount.toString() + " EMRALS",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Send 0.0002 BTC to address:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            new GestureDetector(
              child: Row(
                children: <Widget>[
                  Text(
                    "lkj234lkj2l3k4jlkj2l3kj4lkj2lkj34lkjlkj234lkj",
                    style: TextStyle(
                      fontSize: 17.0,
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
                  new ClipboardData(
                      text: "lkj2lk3jlkj34lkj2l3kj4lkjlkj234lkj234"),
                );
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text("Copied to Clipboard"),
                ));
              },
            ),
            SizedBox(height: 10),
            QrImage(
              data: "23423423lkj234",
              size: 300,
            ),
            SizedBox(height: 10),
            Text(
              widget.emralsAmount.toString() +
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
