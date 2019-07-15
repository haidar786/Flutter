import 'dart:async';
import 'dart:convert';

import 'package:emrals/models/report.dart';
import 'package:emrals/screens/report_detail.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:location/location.dart' as location_manager;

class MapPage extends StatefulWidget {
  final Report report;

  MapPage({Key key, this.report}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MapPage> {
  final Completer<GoogleMapController> completer =
      Completer<GoogleMapController>();
  List<Report> reports = [];
  bool singleReport;
  Future<Set<Marker>> markerFuture;

  @override
  void initState() {
    super.initState();
    singleReport = widget.report != null;
    markerFuture = singleReport
        ? Future.value(Set<Marker>.of([reportToMarker(widget.report)]))
        : loadReports();
    if (singleReport) {
      centreCamera(LatLng(widget.report.latitude, widget.report.longitude));
    } else {
      centreCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: singleReport
          ? AppBar(
              title: Text('Emrals Map'),
              actions: [
                IconButton(
                  tooltip: 'Open in map app',
                  icon: Icon(Icons.launch),
                  onPressed: () {
                    widget.report.launchMaps();
                  },
                ),
              ],
            )
          : null,
      body: FutureBuilder(
          future: markerFuture,
          builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                onMapCreated: _onMapCreated,
                markers: snapshot.data,
                myLocationEnabled: true,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0.0, 0.0),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Text('Unable to load reports.'),
            );
          }),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    if (completer.isCompleted == false) completer.complete(controller);
  }

  Future<LatLng> getUserLocation() async {
    final Location location = location_manager.Location();
    //try {
    final LocationData currentLocation = await location.getLocation();
    return LatLng(currentLocation.latitude, currentLocation.longitude);
    // } catch (e) {
    //   return null;
    // }
  }

  Future<void> centreCamera([LatLng latLng]) async {
    final GoogleMapController mapController = await completer.future;
    final LatLng center = latLng ?? await getUserLocation();
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: center ?? LatLng(0, 0),
          zoom: 15.0,
        ),
      ),
    );
  }

  Future<Set<Marker>> loadReports() async {
    String reportListUrl;
    final Location location = location_manager.Location();
    final LocationData currentLocation = await location.getLocation();
    reportListUrl =
        '$apiUrl/alerts/?longitude=${currentLocation.longitude}&latitude=${currentLocation.latitude}';
    final http.Response response = await http.get(reportListUrl);
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> parsed = data["results"];
    reports = parsed.map((d) => Report.fromJson(d)).toList();
    return Set<Marker>.of(
      reports.map(reportToMarker).toList(),
    );
  }

  Marker reportToMarker(Report report) {
    return Marker(
      markerId: MarkerId(report.id.toString()),
      position: LatLng(report.latitude, report.longitude),
      consumeTapEvents: !singleReport,
      icon: BitmapDescriptor.defaultMarkerWithHue(
          singleReport ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed),
      onTap: !singleReport
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ReportDetail(
                        report: report,
                        reports: reports,
                        showSnackbar: (String message) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                            ),
                          );
                        },
                      ),
                ),
              );
            }
          : null,
      infoWindow:
          InfoWindow(title: report.title, snippet: 'Report #${report.id}'),
    );
  }
}
