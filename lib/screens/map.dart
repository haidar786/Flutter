import 'package:emrals/screens/report_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:emrals/models/report.dart';
import 'package:emrals/styles.dart';
import 'dart:convert';
import 'package:location/location.dart' as LocationManager;
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  final Report report;

  MapPage({Key key, this.report}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MapPage> {
  GoogleMapController mapController;

  var location = Location();
  var currentLocation = <String, double>{};

  List<Report> reports = [];

  void onMarkerTapped(Marker m) {
    print(m.options.zIndex);
    print("asd");
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.onMarkerTapped.add((m) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ReportDetail(report: reports[m.options.zIndex.toInt()],)));
    });
    refresh();
  }

  @override
  void initState() {
    super.initState();
    refresh();
    loadReports();
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
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
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: center == null ? LatLng(0, 0) : center,
          zoom: 15.0,
        ),
      ),
    );
    if (widget.report != null) {
      mapController.addMarker(
        MarkerOptions(
          position: center,
          infoWindowText: InfoWindowText(
              widget.report.title, 'Report #' + widget.report.id.toString()),
        ),
      );
    }
  }

  Future<void> loadReports() async {
    final http.Response response = await http.get(apiUrl + 'alerts/');
    var data = json.decode(response.body);
    var parsed = data["results"] as List;
    setState(() {
      reports = parsed.map((d) => Report.fromJson(d)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    reports.forEach((report) {
      mapController.addMarker(
        MarkerOptions(
          position: LatLng(report.latitude, report.longitude),
          consumeTapEvents: true,
          zIndex: reports.indexOf(report).toDouble(),
        ),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Emrals Map'),
      ),
      body: Hero(
        tag: widget.report != null ? widget.report.id : '',
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          trackCameraPosition: true,
          myLocationEnabled: true,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0.0, 0.0),
          ),
        ),
      ),
    );
  }
}
