import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Capital.dart';
class Ecran1 extends StatefulWidget {
  @override
  _Ecran1State createState() => _Ecran1State();
}

class _Ecran1State extends State<Ecran1> {
  late GoogleMapController mapController;
  final Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();
    // Initialiser la carte avec les capitales depuis le fichier JSON
    loadCapitals();
  }
  List<Capital> capitals = [];
  Future<void> loadCapitals() async {
    String jsonString = await rootBundle.loadString('assets/Capital.json');
    Map<String, dynamic> data = json.decode(jsonString);

    setState(() {

      markers.addAll((data['capitals'] as List).map((capital) {
        Capital c = Capital.fromJson(capital);
        return Marker(
          markerId: MarkerId(c.name),
          position: LatLng(c.lat, c.lng),
          infoWindow: InfoWindow(title: c.name, snippet: 'Population: ${c.population}'),
        );
      }).toSet());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte des Capitales'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(48.8566, 2.3522), // Paris
          zoom: 4,
        ),
        markers: markers,
        myLocationEnabled: true,
      ),
    );
  }
}