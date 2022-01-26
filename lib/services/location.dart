

import 'package:geolocator/geolocator.dart';

class Location {
  late double latitude;
  late double longitude;

  var  getCurrentPosition;

  Future<void> getCurrentLocation() async {
    try {
      Position position =
      await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}