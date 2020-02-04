import 'package:emrals/components/animated_user_emrals.dart';
import 'package:emrals/localizations.dart';
import 'package:emrals/screens/camera.dart';
import 'package:emrals/screens/report_list.dart';
//import 'package:emrals/screens/scanner.dart';
import 'package:emrals/screens/map.dart';
import 'package:emrals/screens/stats.dart';
import 'package:emrals/screens/zone_list.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:emrals/state_container.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/data/database_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int _selectedIndex = 0;
  final PageController pageController = PageController();
  final List<Widget> _children = [
    ViewReportsScreen(),
    ZoneListScreen(),
    ReportScreen(),
    StatsScreen(),
    MapPage(),
    //ScannerScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      RestDatasource()
          .updateEmralsBalance(StateContainer.of(context).loggedInUser.token)
          .then((m) {
        StateContainer.of(context).loggedInUser.emrals =
            double.tryParse(m['emrals_amount']);
        DatabaseHelper().updateUser(StateContainer.of(context).loggedInUser);
        StateContainer.of(context).refreshUser();
      });
      StateContainer.of(context).refreshUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _appLocalization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: RaisedButton.icon(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          color: emralsColor(),
          splashColor: emralsColor(),
          //disabledColor: emralsColor(),
          highlightColor: emralsColor().shade700,
          disabledTextColor: emralsColor(),
          textColor: emralsColor(),
          /* borderSide: BorderSide(
                      color: emralsColor(),
                    ), */
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/buy',
            );
          },
          label: Text(
            _appLocalization.buyEmrals,
            style: TextStyle(color: Colors.white),
          ),
          shape: StadiumBorder(
            side: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: AnimatedUserEmrals(
              initialEmrals: StateContainer.of(context).emralsBalance,
            ),
          ),
          IconButton(
            icon: Image.asset("assets/JustElogo.png"),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkGrey,
        selectedItemColor: emralsColor(),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            this._selectedIndex = index;
          });
          pageController.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.view_agenda,
            ),
            title: Text(_appLocalization.activity),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
            ),
            title: Text(_appLocalization.zones),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
            ),
            title: Text(_appLocalization.report),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.multiline_chart,
            ),
            title: Text(_appLocalization.stats),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     FontAwesomeIcons.qrcode,
          //   ),
          //   title: Text('Scan'),
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.map,
            ),
            title: Text(_appLocalization.map),
          ),
        ],
      ),
    );
  }
}
