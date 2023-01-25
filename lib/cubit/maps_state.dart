// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'maps_cubit.dart';

class MapsState {
  final MapsEnum currentLocationStatus;
  final MapsEnum placesApiStatus;
  final double? longitude;
  final double? latitude;
  final Set<Marker>? markers;

  MapsState({
    this.currentLocationStatus = MapsEnum.initial,
    this.placesApiStatus = MapsEnum.initial,
    this.latitude,
    this.longitude,
    this.markers = const {},
  });

  MapsState copyWith({
    MapsEnum? currentLocationStatus,
    MapsEnum? placesApiStatus,
    double? longitude,
    double? latitude,
    Set<Marker>? markers,
  }) {
    return MapsState(
      currentLocationStatus: currentLocationStatus ?? this.currentLocationStatus,
      placesApiStatus: placesApiStatus ?? this.placesApiStatus,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      markers: markers ?? this.markers,
    );
  }
}
