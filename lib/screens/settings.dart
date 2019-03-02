import 'package:barcode_scan/barcode_scan.dart';
import 'package:emrals/components/animated_user_emrals.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/leaderboard.dart';
import 'package:emrals/screens/profile.dart';
import 'package:emrals/state_container.dart';
import 'package:emrals/styles.dart';
import 'package:emrals/utils/qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:simple_permissions/simple_permissions.dart';

class Settingg extends StatefulWidget {
  const Settingg({Key key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<Settingg> {
  final key = new GlobalKey<ScaffoldState>();
  final formatter = new NumberFormat("#,###");
  final TextEditingController walletAddressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => walletAddressController.text = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          walletAddressController.text =
              'The user did not grant the camera permission!';
        });
      } else {
        setState(() => walletAddressController.text = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => walletAddressController.text =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => walletAddressController.text = 'Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = StateContainer.of(context).loggedInUser;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: key,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.account_circle),
                text: 'profile',
              ),
              Tab(
                icon: Icon(Icons.archive),
                text: 'receive',
              ),
              Tab(
                icon: RotatedBox(
                  quarterTurns: 2,
                  child: Icon(Icons.archive),
                ),
                text: 'send',
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: AnimatedUserEmrals(
                initialEmrals: StateContainer.of(context).emralsBalance,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/JustElogo.png",
                width: 32,
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: RestDatasource()
                        .getUser(StateContainer.of(context).loggedInUser.id),
                    builder: (ctx, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return ProfilePage(userProfile: snapshot.data);
                    },
                  ),
                  Container(
                      height: 30.0,
                      width: 120.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.black12,
                        color: emralsColor(),
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            SimplePermissions.requestPermission(
                                    Permission.ReadContacts)
                                .then((p) {
                              if (p == PermissionStatus.authorized) {
                                Navigator.pushNamed(context, '/contacts');
                              }
                            });
                          },
                          child: Center(
                            child: Text(
                              'Invite Contacts',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 25.0),
                  Container(
                      height: 30.0,
                      width: 120.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.black12,
                        color: Color.fromRGBO(164, 211, 34, 1),
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => LeaderBoard(
                                      currentUser: loggedInUser,
                                    ),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              'Leaderboard',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 25.0),
                  Container(
                      height: 30.0,
                      width: 120.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.black12,
                        color: Color.fromRGBO(164, 211, 34, 1),
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/uploads');
                          },
                          child: Center(
                            child: Text(
                              'Uploads',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 25.0),
                  Container(
                    height: 30.0,
                    width: 120.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.black12,
                      color: Color.fromRGBO(8, 158, 178, 1),
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {
                          var db = DatabaseHelper();
                          db.deleteUsers().then((_) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "/login", ModalRoute.withName("/home"));
                          });
                        },
                        child: Center(
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Version APP_VERSION_NUMBER (BUILD_NUMBER)",
                      textScaleFactor: .9,
                      style: TextStyle(),
                    ),
                  ),
                ],
              ),
            ),
            Center(
                child: Column(
              children: <Widget>[
                SizedBox(height: 15.0),
                Text(
                  'wallet address',
                  style: TextStyle(fontSize: 17.0),
                ),
                SizedBox(height: 25.0),
                new GestureDetector(
                  child: Text(
                    loggedInUser.emralsAddress ?? "",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Clipboard.setData(
                      new ClipboardData(text: loggedInUser.emralsAddress),
                    );
                    key.currentState.showSnackBar(new SnackBar(
                      content: new Text("Copied to Clipboard"),
                    ));
                  },
                ),
                SizedBox(height: 15.0),
                QrImage(
                  data: loggedInUser.emralsAddress ?? "",
                  size: 300,
                ),
              ],
            )),
            Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  Text(
                    "Wallet Address",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            validator: (s) {
                              if (s.isEmpty) {
                                return "Please enter a valid wallet address";
                              }
                            },
                            controller: walletAddressController,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  borderSide:
                                      BorderSide(color: Colors.black54)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            width: 30,
                            height: 30,
                            color: Colors.black54,
                            child: IconButton(
                              icon: Icon(Icons.nfc),
                              color: Colors.white,
                              onPressed: () {
                                scan();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Amount",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (s) {
                      if (double.tryParse(s) != null &&
                          double.tryParse(s) > 0) {
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
                    onTap: () {
                      if (formKey.currentState.validate()) {
                        String walletAddress = walletAddressController.text;
                        double amount =
                            double.tryParse(amountController.text) ??
                                key.currentState.showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Please enter a valid amount"),
                                  ),
                                );

                        if (loggedInUser.emrals >= amount) {
                          RestDatasource()
                              .sendEmrals(
                                  amount, walletAddress, loggedInUser.token)
                              .then((m) {
                            key.currentState
                                .showSnackBar(SnackBar(content: Text(m)));
                            StateContainer.of(context).updateEmrals(
                                StateContainer.of(context).emralsBalance -
                                    amount);
                          });
                        } else {
                          key.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  "You don't have enough emrals for that!")));
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration:
                          BoxDecoration(color: Theme.of(context).accentColor),
                      child: Center(
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
