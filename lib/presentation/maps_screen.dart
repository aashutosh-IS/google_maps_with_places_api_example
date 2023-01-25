import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_mvp/cubit/maps_cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                  onTap: () {
                    if (_textEditingController.text.isNotEmpty) {
                      context.read<MapsCubit>().retriveNearByPlances(
                          locationText: _textEditingController.text);
                    }
                  },
                  child: const Icon(Icons.search)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _textEditingController,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.all(8.0),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Type your text",
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    _textEditingController.clear();
                  });
                  context.read<MapsCubit>().resetMarkers();
                },
                child: const Icon(Icons.delete)),
          ],
        ),
        body: BlocBuilder<MapsCubit, MapsState>(
          builder: (context, state) {
            if (state.currentLocationStatus == MapsEnum.success) {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    state.latitude!,
                    state.longitude!,
                  ),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: state.markers!,
                onTap: (argument) {},
              );
            } else if (state.currentLocationStatus == MapsEnum.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Text(state.toString());
            }
          },
        ));
  }
}
