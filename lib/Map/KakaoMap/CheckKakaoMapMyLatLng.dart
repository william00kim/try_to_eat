import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class CheckKakaoMapMyLatLng {

  Future<void> CheckMapPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.deniedForever) {
      permission = await Geolocator.checkPermission();
    }
    // if(permission == LocationPermission.){
    //   permission = await Geolocator.requestPermission();
    // }
  }

  Future<LatLng> CheckMyLocation() async {

    await Future.delayed(const Duration(seconds: 3));

    print("시작");
    Position MyLoc = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    print("위치 정보");
    print(MyLoc!.latitude);
    print(MyLoc!.longitude);

    var LatLngName = LatLng(MyLoc!.latitude, MyLoc!.longitude);
    return LatLngName;
  }

}