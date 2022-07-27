import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

//import 'package:latlong/latlong.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  List<CircleMarker> _circles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FlutterMap(
        options: MapOptions(
            //center: LatLng(0.65464, 0.56464),
            onTap: (tapPos, latlng) {
          print(latlng.toString());
          //markLocation(latlng);
        }),
        layers: [
          TileLayerOptions(
              urlTemplate:
                  'https://core-sat.maps.yandex.net/tiles?v=3.569.0&x={x}&y={y}&z={z}&lang=tr_TR'),
          TileLayerOptions(
              urlTemplate:
                  'http://vec{s}.maps.yandex.net/tiles?l=skl&v=20.06.03&z={z}&x={x}&y={y}&scale=1&lang=tr_TR',
              subdomains: ['01', '02', '03', '04'],
              backgroundColor: Colors.transparent),
          CircleLayerOptions(circles: _circles),
          MarkerLayerOptions(markers: _markers)
        ],
        mapController: _mapController,
      )),
    );
  }
}
