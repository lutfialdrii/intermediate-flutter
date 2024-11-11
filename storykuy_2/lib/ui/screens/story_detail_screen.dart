// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import '../../data/model/get_all_stories_response.dart';
import '../../helper/util.dart';

class StoryDetailScreen extends StatefulWidget {
  final Story story;
  const StoryDetailScreen({
    super.key,
    required this.story,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final Set<Marker> markers = {};
  late GoogleMapController mapController;
  geo.Placemark? placemark;

  @override
  void initState() {
    super.initState();
    if (widget.story.lat != null && widget.story.lon != null) {
      final marker = Marker(
        markerId: MarkerId(
          "${widget.story.name}",
        ),
        position: LatLng(widget.story.lat!, widget.story.lon!),
      );
      markers.add(marker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Detail'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar utama
            Hero(
              tag: widget.story.photoUrl!,
              child: Image.network(
                widget.story.photoUrl!,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Story
                      Text(
                        widget.story.name!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tanggal dibuat
                      Text(
                        formatDate(widget.story.createdAt!),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Divider(height: 24, thickness: 1),
                      // Deskripsi
                      Text(
                        widget.story.description ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.story.lat != null && widget.story.lon != null)
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  "Story Location",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            if (widget.story.lat != null && widget.story.lon != null)
              Container(
                padding: const EdgeInsets.all(16).copyWith(top: 0),
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.story.lat!, widget.story.lon!),
                    zoom: 18,
                  ),
                  onMapCreated: (controller) async {
                    final info = await geo.placemarkFromCoordinates(
                        widget.story.lat!, widget.story.lon!);
                    final place = info[0];
                    final street = place.street!;
                    final address =
                        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                    setState(() {
                      placemark = place;
                    });
                    defineMarker(LatLng(widget.story.lat!, widget.story.lon!),
                        street, address);
                    setState(() {
                      mapController = controller;
                    });
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  void defineMarker(LatLng latlng, String street, String address) {
    final marker = Marker(
        markerId: MarkerId(widget.story.name!),
        position: latlng,
        infoWindow: InfoWindow(title: street, snippet: address));

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
