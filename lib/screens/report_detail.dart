import 'package:flutter/material.dart';
import 'package:emrals/models/report.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      body: FadeInImage(
        placeholder: new AssetImage("assets/placeholder.png"),
        image: new CachedNetworkImageProvider(report.thumbnail),
      ),
    );
  }
}
