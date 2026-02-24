import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong_to_place/latlong_to_place.dart';

import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());
  final GeocodingService _geo = GeocodingService();
  void getCurrentLocation() async {
    emit(LocationLoading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationFailure("Location services are disabled"));
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationFailure("Location permissions are denied"));
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(LocationFailure("Location permissions are permanently denied"));
        return;
      }
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
      );
      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      final address = await _geo.getPlaceInfo(
        position.latitude,
        position.longitude,
      );

      emit(
        LocationSuccess(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address.formattedAddress,
        ),
      );
      print(
        "Location: address: ${address.formattedAddress}, lat: ${position.latitude}, long: ${position.longitude}",
      );
    } catch (e) {
      emit(LocationFailure(e.toString()));
    }
  }
}
