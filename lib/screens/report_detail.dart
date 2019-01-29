import 'package:flutter/material.dart';
import 'package:emrals/models/report.dart';

class ReportDetail extends StatelessWidget {

  final Report report;

  ReportDetail({Key key, @required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(report);
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Detail"),
      ),
      body: Image.network(report.thumbnail)
    );
  }
}