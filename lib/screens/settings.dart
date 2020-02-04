import 'package:barcode_scan/barcode_scan.dart';
import 'package:emrals/components/animated_user_emrals.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/localizations.dart';
import 'package:emrals/models/transaction.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/leaderboard.dart';
import 'package:emrals/screens/profile.dart';
import 'package:emrals/state_container.dart';
import 'package:emrals/styles.dart';
import 'package:emrals/utils/network_util.dart';
import 'package:emrals/utils/qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Settings extends StatefulWidget {
  final String sendto;
  const Settings({Key key, this.sendto}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<Settings> {
  final key = new GlobalKey<ScaffoldState>();
  final formatter = new NumberFormat("#,###");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appLocalization = AppLocalizations.of(context);
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: key,
          appBar: AppBar(
            bottom: TabBar(
              labelPadding: EdgeInsets.all(0.0),
              tabs: [
                Tab(
                  icon: Icon(Icons.account_circle),
                  text: _appLocalization.profile,
                ),
                Tab(
                  icon: Icon(Icons.archive),
                  text: _appLocalization.receive,
                ),
                Tab(
                  icon: RotatedBox(
                    quarterTurns: 2,
                    child: Icon(Icons.archive),
                  ),
                  text: _appLocalization.send.toLowerCase(),
                ),
                Tab(
                  icon: Icon(Icons.list),
                  text: _appLocalization.transactions,
                )
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
              Profile(),
              ReceivePage(
                scaffoldKey: key,
              ),
              SendPage(
                scaffoldState: key,
                sendto: widget.sendto,
              ),
              TransactionsPage()
            ],
          ),
        ),
        initialIndex: widget.sendto != null ? 2 : 0);
  }
}

class Profile extends StatefulWidget {
  @override
  ProfileState createState() {
    return new ProfileState();
  }
}

class ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _appLocalization = AppLocalizations.of(context);
    return SingleChildScrollView(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 120,
                child: Material(
                  color: emralsColor(),
                  shape: StadiumBorder(),
                  child: InkWell(
                    customBorder: StadiumBorder(),
                    onTap: () async {
                      Map<PermissionGroup, PermissionStatus> permissions =
                          await PermissionHandler()
                              .requestPermissions([PermissionGroup.contacts]);
                      if (permissions[PermissionGroup.contacts] ==
                          PermissionStatus.granted) {
                        await Navigator.pushNamed(context, '/contacts');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Center(
                        child: Text(
                          _appLocalization.inviteContacts,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: Material(
                  color: Color.fromRGBO(164, 211, 34, 1),
                  shape: StadiumBorder(),
                  child: InkWell(
                    customBorder: StadiumBorder(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => LeaderBoard(
                            currentUser:
                                StateContainer.of(context).loggedInUser,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Center(
                        child: Text(
                          _appLocalization.leaderBoard,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 120,
                child: Material(
                  color: Color.fromRGBO(164, 211, 34, 1),
                  shape: StadiumBorder(),
                  child: InkWell(
                    customBorder: StadiumBorder(),
                    onTap: () {
                      Navigator.pushNamed(context, '/uploads');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Center(
                        child: Text(
                          _appLocalization.uploads,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: Material(
                  color: Color.fromRGBO(8, 158, 178, 1),
                  shape: StadiumBorder(),
                  child: InkWell(
                    customBorder: StadiumBorder(),
                    onTap: () {
                      var db = DatabaseHelper();
                      db.deleteUsers().then((_) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/login", (_) => false);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
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
              ),
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Center(
            child: Text(
              _appLocalization.versionApp,
              textScaleFactor: .9,
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ReceivePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  ReceivePage({this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final _appLocalization = AppLocalizations.of(context);
    User loggedInUser = StateContainer.of(context).loggedInUser;
    return Center(
        child: Column(
      children: <Widget>[
        SizedBox(height: 15.0),
        Text(
          _appLocalization.walletAddress.toLowerCase(),
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
            scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text(_appLocalization.copiedToClipBoard),
            ));
          },
        ),
        SizedBox(height: 15.0),
        QrImage(
          data: loggedInUser.emralsAddress ?? "",
          size: 300,
        ),
      ],
    ));
  }
}

class SendPage extends StatefulWidget {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldState;
  final String sendto;

  SendPage({this.scaffoldState, this.sendto});

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final TextEditingController walletAddressController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  Future scan(AppLocalizations appLocalization) async {
    try {
      String barcode = await BarcodeScanner.scan();
      walletAddressController.text = barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        walletAddressController.text =
            appLocalization.userNotGrantCameraPermission;
      } else {
        walletAddressController.text = appLocalization.unknownError +': $e';
      }
    } on FormatException {
      walletAddressController.text =
          appLocalization.userReturnUsingBack;
    } catch (e) {
      walletAddressController.text = appLocalization.unknownError+': $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = StateContainer.of(context).loggedInUser;
    final _appLocalization = AppLocalizations.of(context);
    return Form(
      key: SendPage.formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Text(
            widget.sendto != null
                ? _appLocalization.sendEmralsto+" " + widget.sendto
                : _appLocalization.walletAddress,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          widget.sendto == null
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          validator: (s) {
                            if (s.isEmpty) {
                              return _appLocalization.pleaseEnterValidWalletAddress;
                            }
                            return null;
                          },
                          controller: walletAddressController,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(color: Colors.black54)),
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
                              scan(_appLocalization);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(height: 0),
          SizedBox(height: 25),
          Text(
            _appLocalization.amount,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextFormField(
            validator: (s) {
              if (double.tryParse(s) != null && double.tryParse(s) > 0) {
                return null;
              } else {
                return _appLocalization.enterValidAmount;
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
              if (SendPage.formKey.currentState.validate()) {
                String walletAddress = walletAddressController.text;
                String sendto = widget.sendto;
                double amount = double.tryParse(amountController.text) ??
                    widget.scaffoldState.currentState.showSnackBar(
                        SnackBar(content: Text(_appLocalization.enterValidAmount)));

                if (loggedInUser.emrals >= amount) {
                  RestDatasource()
                      .sendEmrals(
                          amount, walletAddress, sendto, loggedInUser.token)
                      .then((m) {
                    widget.scaffoldState.currentState
                        .showSnackBar(SnackBar(content: Text(m)));
                    if (m != "Invalid Emrals Address") {
                      StateContainer.of(context).updateEmrals(
                          StateContainer.of(context).emralsBalance - amount);
                    }
                  });
                } else {
                  widget.scaffoldState.currentState.showSnackBar(SnackBar(
                      content: Text(_appLocalization.notHaveEnoughEmrals+"!")));
                }
              }
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
              child: Center(
                child: Text(
                  _appLocalization.send,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TransactionsPage extends StatelessWidget {
  final List<String> transactionTypes = [
    "Impact Zone Contribution",
    "GCP",
    "User Transaction",
    "Tip for Report",
    "Tip for Cleanup"
  ];

  @override
  Widget build(BuildContext context) {
    User loggedInUser = StateContainer.of(context).loggedInUser;
    Map<String, String> headers = {
      "Authorization": "token ${loggedInUser.token}",
      "Content-type": "application/json"
    };

    return FutureBuilder(
        future: NetworkUtil().get(apiUrl + "/transactions/", headers),
        builder: (context, snapshot) {
          final _appLocalization = AppLocalizations.of(context);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<Transaction> transactions = [];
          List<Map<String, dynamic>> response = List.from(snapshot.data);
          response.forEach((m) {
            transactions.add(Transaction.fromJSON(m));
          });

          return transactions.isEmpty
              ? Center(
                  child: Text(_appLocalization.noTransactionMade),
                )
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (ctx, index) {
                    Transaction transaction = transactions[index];
                    return InkWell(
                      onTap: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (ctx) => ProfileDialog(
                        //           id: transaction.id,
                        //         ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  transaction.note == "reporting"
                                      ? _appLocalization.tippedUserReportingAlert+" #" +
                                          transaction.alert.toString()
                                      : transaction.note == "cleaning"
                                          ? _appLocalization.tippedUserCleaningAlert+" #" +
                                              transaction.alert.toString()
                                          : transaction.subscription != null
                                              ? _appLocalization.subscriptionId+":" +
                                                  transaction.subscription
                                                      .toString()
                                              : transaction.note,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
//                          Text(
//                            transaction.subscription ?? "",
//                            style: TextStyle(fontSize: 14),
//                          ),
                                SizedBox(height: 3),
                                Text(
                                  DateFormat.yMMMd()
                                      .format(transaction.created),
                                  style: TextStyle(color: Colors.black38),
                                )
                              ],
                            ),
                            transaction.amount != null
                                ? Text(
                                    "${transaction.amount > 0 ? "-" : "+"}${transaction.amount.round()}",
                                    style: TextStyle(
                                        color: transaction.amount < 0
                                            ? emralsColor()
                                            : emralsColor()[1300],
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    );
                  },
                );
        });
  }
}
