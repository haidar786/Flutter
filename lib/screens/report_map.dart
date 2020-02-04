import 'package:emrals/localizations.dart';
import 'package:emrals/models/report.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportMap extends StatelessWidget {
  ReportMap({Key key, @required this.report})
      : assert(report != null),
        marker = _reportToMarker(report),
        super(key: key);

  final Report report;
  final Marker marker;

  /// Creates a Google Map [Marker] from an Emrals [Report]
  static Marker _reportToMarker(Report report) {
    return Marker(
      markerId: MarkerId(report.id.toString()),
      position: LatLng(report.latitude, report.longitude),
      consumeTapEvents: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: report.title,
        snippet: 'Report #${report.id}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appLocalization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_appLocalization.emralsMap),
        actions: [
          IconButton(
            tooltip: _appLocalization.openInMapApp,
            icon: const Icon(Icons.launch),
            onPressed: () => report.launchMaps(),
          ),
        ],
      ),
      body: GoogleMap(
        markers: <Marker>{marker},
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(report.latitude, report.longitude),
          zoom: 16,
        ),
      ),
    );
  }
}
