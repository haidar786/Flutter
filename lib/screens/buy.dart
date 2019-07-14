import 'package:emrals/screens/send_btc.dart';
import 'package:flutter/material.dart';
import 'package:emrals/state_container.dart';
import 'package:flutter/services.dart';
import 'package:emrals/data/rest_ds.dart';

class BuyEmralsScreen extends StatefulWidget {
  @override
  _BuyEmralsScreenState createState() => _BuyEmralsScreenState();
}

class _BuyEmralsScreenState extends State<BuyEmralsScreen> {
  final TextEditingController walletAddressController = TextEditingController();

  final TextEditingController amountController = TextEditingController();
  String sendBitcoin = "Send BTC";
  String oldAmount = "";

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
            Text(
              "Amount of EMRALS to buy",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextFormField(
              autovalidate: true,
              validator: (s) {
                if (s != oldAmount) {
                  if (double.tryParse(s) != null && double.tryParse(s) > 100) {
                    oldAmount = s;
                    RestDatasource()
                        .getEmralsprice(int.tryParse(s),
                            StateContainer.of(context).loggedInUser.token)
                        .then((price) {
                      setState(() {
                        print(price);
                        if (price == "error") {
                          sendBitcoin = "Error: " + s + " EMRALS not available";
                        } else {
                          sendBitcoin = "Send " + price + " BTC";
                        }
                      });
                    });

                    return null;
                  } else {
                    return "Please enter a valid amount > 100";
                  }
                }
                return null;
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
              onTap: () {
                print('tapped');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendBTCScreen(
                      emralsAmount: int.tryParse(oldAmount),
                      key: UniqueKey(),
                    ),
                  ),
                );
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
                child: Center(
                  child: Text(
                    sendBitcoin,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Emrals charges no fees when you buy or sell EMRALS.",
              style: TextStyle(color: Colors.black26),
            ),
            SizedBox(height: 30),
            Text(
              "However, Emrals may apply an exchange rate based on the size of your transaction and a spread determined by volatility across exchanges.",
              style: TextStyle(color: Colors.black26),
            ),
          ],
        ),
      ),
    );
  }
}
