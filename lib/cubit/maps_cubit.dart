import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_mvp/presentation/maps_detail_screen.dart';
import 'package:google_maps_mvp/service/navigation_service.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

part 'maps_state.dart';

enum MapsEnum { loading, success, failed, initial }

class MapsCubit extends Cubit<MapsState> {
  MapsCubit() : super(MapsState());

  getUserCurrentLocation() async {
    emit(state.copyWith(currentLocationStatus: MapsEnum.loading));
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      emit(state.copyWith(
        currentLocationStatus: MapsEnum.success,
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    }
  }

  Future<void> retriveNearByPlances({required String locationText}) async {
    emit(state.copyWith(placesApiStatus: MapsEnum.loading));

    final places =
        GoogleMapsPlaces(apiKey: "YOUR_API_KEY");
    PlacesSearchResponse response = await places.searchNearbyWithRadius(
      Location(lat: state.latitude!, lng: state.longitude!),
      10000,
      type: locationText.trim(),
    );
    for (var element in response.results) {
      log(element.name);
    }
    Set<Marker> placesMarkers = response.results
        .map((result) => Marker(
              markerId: MarkerId(result.name),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure,
              ),
              infoWindow: InfoWindow(
                  title: result.name,
                  snippet: "Address: ${result.formattedAddress}",
                  onTap: () {
                    final NavigationService navigationService =
                        locator<NavigationService>();
                    navigationService.navigateTo(
                      MapsDetailScreen(result: result),
                    );
                  }),
              position: LatLng(
                  result.geometry!.location.lat, result.geometry!.location.lng),
              onTap: () async {
              },
            ))
        .toSet();

    emit(state.copyWith(
      placesApiStatus: MapsEnum.success,
      markers: Set.of(state.markers!)..addAll(placesMarkers),
    ));
  }

  void resetMarkers() {
    emit(state.copyWith(markers: {}));
  }
}
