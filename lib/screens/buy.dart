import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class BuyEmralsScreen extends StatefulWidget {
  @override
  _BuyEmralsScreenState createState() => _BuyEmralsScreenState();
}

class _BuyEmralsScreenState extends State<BuyEmralsScreen> {
  final TextEditingController walletAddressController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //User loggedInUser = StateContainer.of(context).loggedInUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Emrals'),
      ),
      body: Form(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(16),
          children: <Widget>[
            // Text(
            //   "Wallet Address",
            //   style: TextStyle(fontSize: 16),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // IntrinsicHeight(
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: <Widget>[
            //       Expanded(
            //         child: TextFormField(
            //           validator: (s) {
            //             if (s.isEmpty) {
            //               return "Please enter a valid wallet address";
            //             }
            //           },
            //           controller: walletAddressController,
            //           style: TextStyle(fontSize: 18),
            //           decoration: InputDecoration(
            //             contentPadding: EdgeInsets.all(10),
            //             border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(0),
            //                 borderSide: BorderSide(color: Colors.black54)),
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 10),
            //       AspectRatio(
            //         aspectRatio: 1,
            //         child: Container(
            //           width: 30,
            //           height: 30,
            //           color: Colors.black54,
            //           child: IconButton(
            //             icon: Icon(Icons.nfc),
            //             color: Colors.white,
            //             onPressed: () {},
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // SizedBox(height: 25),
            Text(
              "Amount",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (s) {
                if (double.tryParse(s) != null && double.tryParse(s) > 0) {
                  return null;
                } else {
                  return "Please enter a valid amount";
                }
              },
              controller: amountController,
              style: TextStyle(fontSize: 22),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Align(
                    widthFactor: 1,
                    child: Text(
                      "EMRALS",
                      style: TextStyle(color: Colors.black26),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide(color: Colors.black54)),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 60,
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
                child: Center(
                  child: Text(
                    "Send .001 BTC",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
