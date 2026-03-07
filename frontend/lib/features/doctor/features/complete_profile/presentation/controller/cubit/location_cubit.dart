import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong_to_place/latlong_to_place.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';

import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this._repo) : super(LocationInitial());
  final DoctorCompleteProfileRepo _repo;
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

      final locationResult = await _repo.completeLocation(
        clinicAddress: address.formattedAddress,
        lat: position.latitude,
        lng: position.longitude,
        label: address.formattedAddress,
      );

      final hasFailure = locationResult.fold((_) => true, (_) => false);
      if (hasFailure) {
        final error = locationResult.fold((failure) => failure.message, (_) => '');
        emit(LocationFailure(error));
        return;
      }

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
