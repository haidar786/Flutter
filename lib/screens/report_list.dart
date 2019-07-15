import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/components/animated_text.dart';
import 'package:emrals/data/report_api.dart';
import 'package:emrals/models/report.dart';
import 'package:emrals/screens/camera.dart';
import 'package:emrals/screens/map.dart';
import 'package:emrals/screens/profile.dart';
import 'package:emrals/screens/report_detail.dart';
import 'package:emrals/state_container.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/data/database_helper.dart';

class ViewReportsScreen extends StatefulWidget {
  @override
  _ViewReportsScreen createState() => _ViewReportsScreen();
}

class _ViewReportsScreen extends State<ViewReportsScreen>
    with TickerProviderStateMixin {
  final formatter = NumberFormat("#,###");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ReportApi reportApi = ReportApi();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          child: SizedBox(
            height: 30.0,
            child: Material(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'RECENT',
                  ),
                  Tab(
                    text: 'CLOSEST',
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(30.0),
        ),
        body: TabBarView(
          children: [
            ReportListPage(
              reportFilter: ReportFilter.RECENT,
              reportApi: reportApi,
            ),
            ReportListPage(
              reportFilter: ReportFilter.CLOSEST,
              reportApi: reportApi,
            ),
          ],
        ),
      ),
    );
  }
}

class ReportWidget extends StatelessWidget {
  final Report report;
  final VoidCallback onTipPressed;
  final bool animateText;
  final formatter = NumberFormat("#,###");

  ReportWidget(
      {Key key,
      this.report,
      @required this.onTipPressed,
      this.animateText = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => ProfileDialog(id: report.creator));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          stops: [0, 0.5, 1],
                          colors: [
                            const Color(0xFF7DB208),
                            const Color(0xFFFFDC03),
                            const Color(0xFFDD26BA),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              report.posterAvatar,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        report.posterUsername,
                        style: TextStyle(
                            color: emralsColor(), fontWeight: FontWeight.bold),
                      ),
                      Text(report.solution != ''
                          ? 'cleans ${report.timeAgo} ago '
                          : 'reports ${report.timeAgo} ago '),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'earned',
                        style: TextStyle(
                          fontSize: 12,
                          color: emralsColor(),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/greene.png",
                            width: 15,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          animateText
                              ? AnimatedText(
                                  value: double.parse(
                                          report.solutionEmralsAmount) +
                                      double.parse(report.reportEmralsAmount),
                                )
                              : Text(
                                  formatter.format(double.parse(
                                          report.solutionEmralsAmount) +
                                      double.parse(report.reportEmralsAmount)),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: EMRALS_COLOR,
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReportDetail(
                            report: report,
                            reports: [report],
                            showSnackbar: (String message) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(message),
                              ));
                            },
                          )),
                );
              },
              child: Stack(
                children: [
                  CachedNetworkImage(
                    placeholder: (context, _) => AspectRatio(aspectRatio: 1),
                    imageUrl: (report.solution != ''
                            ? report.solution
                            : report.thumbnail) ??
                        '',
                    errorWidget: (context, _, error) => Icon(Icons.error),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                        child: Text(report.title),
                        decoration: BoxDecoration(color: Colors.white70),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5),
                        child: Text(
                          "#" + report.id.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.5, 1.5),
                                blurRadius: 1.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  report.solution != ""
                      ? Positioned(
                          bottom: 10,
                          left: 10,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Before",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image: NetworkImage(report.thumbnail),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Hero(
                      tag: report.id,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapPage(
                                    report: report,
                                    key: UniqueKey(),
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10, bottom: 10),
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff7c94b6),
                            image: DecorationImage(
                              image: NetworkImage(report.googleURL),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            border: Border.all(
                              color: emralsColor(),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton.icon(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    onPressed: report.solution != ''
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReportScreen(report: report),
                              ),
                            );
                          },
                    label: Text(
                      "Clean",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    color: Theme.of(context).accentColor,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    splashColor: emralsColor(),
                    //disabledColor: emralsColor(),
                    highlightColor: emralsColor().shade700,
                    disabledTextColor: emralsColor(),
                    textColor: emralsColor(),
                    /* borderSide: BorderSide(
                      color: emralsColor(),
                    ), */
                    onPressed: () {
                      Share.share(
                          "http://www.emrals.com/alerts/" + report.slug);
                    },
                    child: Text("SHARE"),
                    shape: StadiumBorder(
                      side: BorderSide(color: emralsColor(), width: 2),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.white,
                    splashColor: emralsColor(),
                    //disabledColor: emralsColor(),
                    highlightColor: emralsColor().shade700,
                    disabledTextColor: emralsColor(),
                    textColor: emralsColor(),
                    /* borderSide: BorderSide(
                      color: emralsColor(),
                    ), */
                    onPressed: onTipPressed,
                    child: Text("TIP"),
                    shape: StadiumBorder(
                      side: BorderSide(color: emralsColor(), width: 2),
                    ),
                  ),
                ],
              ),
            ),
            /* Container(
              height: 1,
              color: Colors.grey,
            ) */
          ],
        ),
      ),
    );
  }
}

class ReportListPage extends StatefulWidget {
  final ReportFilter reportFilter;
  final ReportApi reportApi;

  const ReportListPage(
      {Key key, @required this.reportFilter, @required this.reportApi})
      : super(key: key);
  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final int limit = 50;
  PagewiseLoadController<Report> pageLoadController;
  bool refreshedOnce = false;

  @override
  void initState() {
    super.initState();
    pageLoadController = PagewiseLoadController(
      pageSize: 50,
      pageFuture: (int batch) => widget.reportApi.getReports(
            offset: batch * limit,
            limit: limit,
            reportFilter: widget.reportFilter,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          refreshedOnce = true;
        });
        RestDatasource()
            .updateEmralsBalance(StateContainer.of(context).loggedInUser.token)
            .then((m) {
          StateContainer.of(context).loggedInUser.emrals =
              double.tryParse(m['emrals_amount']);
          DatabaseHelper().updateUser(StateContainer.of(context).loggedInUser);
          StateContainer.of(context).refreshUser();
        });
        StateContainer.of(context).refreshUser();

        pageLoadController.reset();
      },
      child: PagewiseListView(
        padding: const EdgeInsets.symmetric(vertical: 6),
        loadingBuilder: (BuildContext context) => Center(
              child: CircularProgressIndicator(),
            ),
        pageLoadController: pageLoadController,
        itemBuilder: (BuildContext context, Report report, int index) =>
            ReportWidget(
              report: report,
              animateText: !refreshedOnce,
              onTipPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return TipDialog(report, (String message) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            action: SnackBarAction(
                              label: 'OKAY',
                              onPressed: () {},
                            ),
                          ),
                        );
                      });
                    }).then((d) {
                  if (d != null) {
                    /* showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content: Container(
                              child: CircularProgressIndicator(),
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                            ),
                          );
                        }); */
                    pageLoadController.reset();
                    StateContainer.of(context).updateEmrals(
                        StateContainer.of(context).emralsBalance - d);
                    /* if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } */
                  }
                });
              },
            ),
        noItemsFoundBuilder: (BuildContext context) => Center(
              child: Text('No posts found.'),
            ),
      ),
    );
  }
}
