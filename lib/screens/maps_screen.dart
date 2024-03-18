import 'dart:async';

import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:app_admin_pizzeria/main.dart';
import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(45.406435, 11.876761),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersProvider>(context).orders;

    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 1.2,
            child: FutureBuilder(
              future: _createMarkers(orders),
              builder: (context, marker) {
                return marker.data != null
                    ? GoogleMap(
                        myLocationEnabled: false,
                        markers: marker.data!,
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      )
                    : const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );
              },
            ),
          )
        ],
      ),
    ));
  }
}

Future<LatLng?> getAddressCoordinates(String address) async {
  try {
    List<Location> locations =
        await locationFromAddress(address, localeIdentifier: "it_IT");

    if (locations.isNotEmpty) {
      Location location = locations[0];

      return LatLng(location.latitude, location.longitude);
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return null;
}

Future<Set<Marker>> _createMarkers(List<OrderData> orders) async {
  final Set<Marker> markers = {};

  for (final order in orders) {
    await _addMarker(markers, order);
  }
  return markers;
}

Future<void> _addMarker(Set<Marker> markers, OrderData order) async {
  if (order.deliveryMethod == "Asporto") {
    return;
  }

  final LatLng? coordinates = await getAddressCoordinates(order.address);

  if (coordinates != null) {
    markers.add(
      Marker(
        markerId: MarkerId(order.name), // Use a unique ID
        position: coordinates,
        infoWindow: InfoWindow(
          title: order.name,
          snippet: order.time,
        ),
      ),
    );
  }
}
