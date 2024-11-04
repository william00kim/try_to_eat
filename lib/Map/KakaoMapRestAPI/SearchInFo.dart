import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:try_to_eat/Map/KakaoMap/CheckKakaoMapMyLatLng.dart';
import 'package:try_to_eat/Map/KakaoMapRestAPI/SearchInFoResListParse.dart';

class SearchInFo{

  List<List<SearchInFoResListParse>> FinalResData = [];

  Future<List<List<SearchInFoResListParse>>> Search(String keyword, LatLng latlng) async {

    print(latlng.latitude);
    print(latlng.longitude);

    FinalResData.clear();

    var response = await http.get(
        Uri.parse("https://dapi.kakao.com/v2/local/search/keyword.json?y=${latlng.longitude}&x=${latlng.latitude}&radius=20000&query=${keyword}"),
        headers: {'Authorization': 'KakaoAK ae2c75c7f2fe4e6fe58246389660e816'},
    );

    Map<String, dynamic> responseBodyMap = jsonDecode(response.body);
    final documents = responseBodyMap["documents"]!;

    if(documents is List<dynamic>) {
      List<SearchInFoResListParse> res = documents.map((value) {
        return SearchInFoResListParse.fromMap(value);
      }).toList();
      for(var i = 0; i<res.length; i++) {
        FinalResData.add(res);
      }
    }

    print('키워드검색 코드 실행됨');
    return FinalResData;

  }

  Future<List<List<SearchInFoResListParse>>> SearchNearbyRes(LatLng Pos) async {

    print("시작1");

    Future.delayed(const Duration(seconds: 2));

    print("주변맛집 검색 위치");
    print("주변 검색: ${Pos.latitude}");
    print("주변 검색: ${Pos.longitude}");

    FinalResData.clear();

    var response = await http.get(
      Uri.parse("https://dapi.kakao.com/v2/local/search/keyword.json?x=${Pos!.longitude}&y=${Pos!.latitude}&radius=2000&query=${"맛집"}"),
      headers: {'Authorization': 'KakaoAK ae2c75c7f2fe4e6fe58246389660e816'},
    );

    Map<String, dynamic> responseBodyMap = jsonDecode(response.body);
    final documents = responseBodyMap["documents"]!;

    print('코드 4');
    if(documents is List<dynamic>) {
      List<SearchInFoResListParse> res = documents.map((value) {
        return SearchInFoResListParse.fromMap(value);
      }).toList();
      for(var i = 0; i<res.length; i++) {
        FinalResData.add(res);
      }
    }
    print('주변검색 코드 실행됨');
    return FinalResData;

  }
}