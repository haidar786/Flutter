import 'package:emrals/localizations.dart';
import 'package:flutter/material.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/offline_report.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class Uploads extends StatefulWidget {
  @override
  UploadsState createState() {
    return UploadsState();
  }
}

class UploadsState extends State<Uploads> {
  _refreshWidget() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).pendingUploads),
      ),
      body: StreamBuilder(
        stream: DatabaseHelper().getReports().asStream(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            List<OfflineReport> reports = List.from(snapshot.data);
            return ReportList(
              reports: reports,
              callback: _refreshWidget,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ReportList extends StatelessWidget {
  final callback;

  final List<OfflineReport> reports;

  ReportList({this.reports, this.callback});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        OfflineReport report = reports[index];
        File file = new File(report.filename);
        String basename = p.basename(file.path);

        return Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(report.filename),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              title: Text(basename),
              subtitle: Text(
                report.latitude.toString() + ", " + report.longitude.toString(),
              ),
              trailing: RaisedButton(
                child: Text(AppLocalizations.of(context).delete),
                onPressed: () {
                  DatabaseHelper().deletereport(report.filename).then((d) {
                    reports.removeWhere(
                        (item) => item.filename == report.filename);
                    callback();
                  });
                },
              ),
            ),
            LinearProgressIndicator(),
          ],
        );
      },
      separatorBuilder: (ctx, index) => Divider(
            height: 0,
            color: Colors.black26,
          ),
      itemCount: reports.length,
    );
  }
}
