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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pending Uploads'),
        ),
        body: FutureBuilder(
          future: DatabaseHelper().getReports(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<OfflineReport> reports = List.from(snapshot.data);
              return ReportList(reports: reports);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class ReportList extends StatelessWidget {
  final List<OfflineReport> reports;

  ReportList({this.reports});

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
              subtitle: Text(report.latitude.toString() +
                  ", " +
                  report.longitude.toString()),
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
