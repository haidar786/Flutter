// import 'package:emrals/data/rest_ds.dart';
// import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';

import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/offline_report.dart';
//import 'package:contacts_service/contacts_service.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class Uploads extends StatefulWidget {
  @override
  ContactsState createState() {
    return ContactsState();
  }
}

class ContactsState extends State<Uploads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Uploads'),
        ),
        body: FutureBuilder(
          future: DatabaseHelper().getReports(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<OfflineReport> reports = List.from(snapshot.data);
              // ..sort(
              //   (c1, c2) {
              //     if (c1.displayName != null && c2.displayName != null) {
              //       return c1.displayName.compareTo(c2.displayName);
              //     }
              //   },
              // )
              // ..sort(
              //   (c1, c2) {
              //     if (c1.emails.length < c2.emails.length) {
              //       return 1;
              //     } else if (c1.emails.length > c2.emails.length) {
              //       return -1;
              //     } else {
              //       return 0;
              //     }
              //   },
              // );
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

        return ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(basename),
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
          // Image(
          //         image: AssetImage(report.filename),
          //       ),
          // leading: CircleAvatar(
          //   foregroundColor: Colors.white,
          //   backgroundImage: MemoryImage(contact.avatar),
          //   child: Text(contact.displayName != null && contact.avatar != null
          //       ? contact.displayName.substring(0, 1)
          //       : ""),
          // ),
          subtitle: Text(
              report.latitude.toString() + ", " + report.longitude.toString()),
          // trailing: contact.emails.length != 0
          //     ? InviteButton(
          //         email: contact.emails.first.value,
          //       )
          //     : null,
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
