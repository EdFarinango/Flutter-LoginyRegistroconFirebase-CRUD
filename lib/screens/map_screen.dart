import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Map<String, Marker> _markers = {};
  late LatLng _currentLocation;
  bool _isLoading = false;
  late String _loggedInUserEmail;

  Stream<Set<Marker>> get _markersStream {
    return FirebaseFirestore.instance
        .collection('usersLocations')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final userId = doc.id;
        final geoPoint = doc['location'] as GeoPoint;
        final location = LatLng(geoPoint.latitude, geoPoint.longitude);

        return Marker(
          markerId: MarkerId(userId),
          position: location,
          infoWindow: InfoWindow(
            title: userId,
          ),
        );
      }).toSet();
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getUserEmail();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _saveUserLocation();

      Timer.periodic(Duration(seconds: 30), (timer) {
        _saveUserLocation();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getUserEmail() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      setState(() {
        _loggedInUserEmail = user['email'];
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveUserLocation() async {
    if (_currentLocation == null) {
      return;
    }

    try {
      final geoPoint =
          GeoPoint(_currentLocation.latitude, _currentLocation.longitude);
      await FirebaseFirestore.instance
          .collection('usersLocations')
          .doc(_loggedInUserEmail)
          .set({
        'location': geoPoint,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  //********************************************* */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicaciones de usuarios'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<Set<Marker>>(
              stream: _markersStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation,
                      zoom: 15,
                    ),
                    markers: snapshot.data!,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }
}
