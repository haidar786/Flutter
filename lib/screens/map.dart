import 'dart:async';
import 'dart:convert';

import 'package:emrals/models/report.dart';
import 'package:emrals/screens/report_detail.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:location/location.dart' as LocationManager;

class MapPage extends StatefulWidget {
  final Report report;

  MapPage({Key key, this.report}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MapPage> {
  final Completer<GoogleMapController> completer =
      Completer<GoogleMapController>();
  Set<Marker> markers;
  List<Report> reports = [];

  @override
  void initState() {
    super.initState();
    if (widget.report == null) {
      markers = Set<Marker>.of(
        reports.map(reportToMarker).toList(),
      );
    } else {
      markers = Set<Marker>.of([reportToMarker(widget.report)]);
    }
    refresh();
    loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emrals Map'),
        actions: widget.report != null
            ? [
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.launch),
                      onPressed: () {
                        widget.report.launchMaps();
                      },
                    ),
                  ],
                )
              ]
            : null,
      ),
      body: Hero(
        tag: widget.report != null ? widget.report.id : '',
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: markers,
          myLocationEnabled: true,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0.0, 0.0),
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    completer.complete(controller);
    refresh();
  }

  Future<LatLng> getUserLocation() async {
    LocationData currentLocation;
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = widget.report != null
          ? LatLng(widget.report.latitude, widget.report.longitude)
          : LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  void refresh() async {
    final center = await getUserLocation();
    final GoogleMapController mapController = await completer.future;
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: center == null ? LatLng(0, 0) : center,
          zoom: 15.0,
        ),
      ),
    );
  }

  Future<void> loadReports() async {
    final http.Response response = await http.get(apiUrl + '/alerts/');
    var data = json.decode(response.body);
    var parsed = data["results"] as List;
    setState(() {
      reports = parsed.map((d) => Report.fromJson(d)).toList();
    });
  }

  Marker reportToMarker(Report report) {
    return Marker(
      markerId: MarkerId(report.id.toString()),
      position: LatLng(report.latitude, report.longitude),
      consumeTapEvents: true,
      zIndex: reports.indexOf(report).toDouble(),
      onTap: () {
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
      },
      infoWindow:
          InfoWindow(title: report.title, snippet: 'Report #${report.id}'),
    );
  }
}
