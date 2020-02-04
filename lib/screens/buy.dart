import 'package:emrals/localizations.dart';
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
  String sendBitcoin;
  String oldAmount = "";

  @override
  Widget build(BuildContext context) {
    //User loggedInUser = StateContainer.of(context).loggedInUser;
    final _appLocalization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_appLocalization.buyEmrals),
      ),
      body: Form(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Text(
              _appLocalization.amountOfEmralsToBuy,
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
                          sendBitcoin = _appLocalization.error+": " + s + " "+ _appLocalization.emralsNotAvailable;
                        } else {
                          sendBitcoin = _appLocalization.send+" " + price + " "+_appLocalization.btc;
                        }
                      });
                    });

                    return null;
                  } else {
                    return _appLocalization.pleaseEnterValidAmountGreaterThan100;
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
                      _appLocalization.emrals,
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
                    sendBitcoin != null ? sendBitcoin : _appLocalization.sendBitcoin,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              _appLocalization.emralsChargesNoFees,
              style: TextStyle(color: Colors.black26),
            ),
            SizedBox(height: 30),
            Text(
              _appLocalization.howeverEmralsMayApplyExchangeRate,
              style: TextStyle(color: Colors.black26),
            ),
          ],
        ),
      ),
    );
  }
}
