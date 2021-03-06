import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

//import 'package:latlong/latlong.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final List<CircleMarker> _circles = [];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Expanded(
            child: FlutterMap(
          options: MapOptions(
              center: LatLng(45.200834, 33.351089),
              zoom: 16.0,
              maxZoom: 18.0,
              onTap: (tapPos, latlng) {
                setState(() {
                  _markers.clear();
                  _markers.add(Marker(
                    //width: 80.0,
                    //height: 80.0,
                    point: latlng,
                    builder: (ctx) => const Icon(
                      Icons.location_on,
                      size: 20.0,
                      color: Colors.red,
                    ),
                  ));
                });
                Navigator.of(context).pop(latlng);
            //markLocation(latlng);
          }),
          layers: [
            //TileLayerOptions(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png", userAgentPackageName: 'com.example.app',),
            TileLayerOptions(
              urlTemplate: 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}&hl=ru-RU&scale=1&xss=1&yss=1&s=G5zdHJ1c3Q%3D&client=gme-google&style=api%3A1.0.0&key=AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY'
            ),
            //TileLayerOptions(urlTemplate: 'https://core-sat.maps.yandex.net/tiles?l=sat&v=3.569.0&x={x}&y={y}&z={z}&lang=tr_TR'),
            //TileLayerOptions(urlTemplate: 'http://vec{s}.maps.yandex.net/tiles?l=map&v=20.26.0&z={z}&x={x}&y={y}&scale=1&lang=ru_RU', subdomains: ['01', '02', '03', '04'], backgroundColor: Colors.transparent),
            CircleLayerOptions(circles: _circles),
            MarkerLayerOptions(markers: _markers)
          ],
          nonRotatedChildren: [
              AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                  onSourceTapped: null,
              ),
          ],
          mapController: _mapController,
        )),
      ),
    );
  }
}
