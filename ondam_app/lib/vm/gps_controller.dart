import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/moving_handler.dart';

class GpsController extends  MovingController{

  // 위치 정보
  final latitude = ''.obs;
  final longitude = ''.obs;

  // GPS
  Future<void> checkLocationPermission() async{
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    if(permission == LocationPermission.deniedForever) return;

    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      final position = await Geolocator.getCurrentPosition();
      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();
    }
  }
}