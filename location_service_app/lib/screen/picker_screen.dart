import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../widget/placemark_widget.dart';

class PickerScreen extends StatefulWidget {
  const PickerScreen({super.key});

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);

  late GoogleMapController mapController;

  late final Set<Marker> markers = {};

  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: dicodingOffice,
              zoom: 18,
            ),
            markers: markers,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) async {
              final info = await geo.placemarkFromCoordinates(
                  dicodingOffice.latitude, dicodingOffice.longitude);
              final place = info[0];
              final street = place.street!;
              final address =
                  '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
              setState(() {
                placemark = place;
              });
              defineMarker(dicodingOffice, street, address);

              setState(() {
                mapController = controller;
              });
            },
            onLongPress: (latlng) {
              onLongPressGMap(latlng);
            },
          ),
          Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  onMyLocationButtonPress();
                },
                child: const Icon(Icons.my_location),
              )),
          if (placemark == null)
            const SizedBox()
          else
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: PlacemarkWidget(
                placemark: placemark!,
              ),
            ),
        ],
      )),
    );
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('Location services is not available');
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('location permission denied!');
        return;
      }
    }

    locationData = await location.getLocation();
    final latlng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latlng, street!, address);

    mapController.animateCamera(CameraUpdate.newLatLng(latlng));
  }

  void defineMarker(LatLng latlng, String street, String address) {
    final marker = Marker(
        markerId: MarkerId("source"),
        position: latlng,
        infoWindow: InfoWindow(title: street, snippet: address));

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  Future<void> onLongPressGMap(LatLng latlng) async {
    final info =
        await geo.placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latlng, street!, address);
    mapController.animateCamera(CameraUpdate.newLatLng(latlng));
  }
}
