import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:try_to_eat/InnerDatabase/InnerDatabaseClass.dart';
import 'package:try_to_eat/InnerDatabase/SearchDBDataModel.dart';
import 'package:try_to_eat/Map/KakaoMapRestAPI/SearchInFo.dart';

import '../Map/KakaoMap/CheckKakaoMapMyLatLng.dart';
import '../UserInterface/RestaurantDetail.dart';

class Searchbanner extends StatefulWidget {
  const Searchbanner({Key? key, this.onBannerDismissed, required this.SearchKeyword}) : super(key: key);

  final VoidCallback? onBannerDismissed;
  final String SearchKeyword;

  @override
  State<Searchbanner> createState() => _SearchbannerState();
}

class _SearchbannerState extends State<Searchbanner> with SingleTickerProviderStateMixin{

  late AnimationController _controller;

  static const Curve curve = Curves.fastOutSlowIn;

  SearchInFo _searchInFo = SearchInFo();
  Innerdatabaseclass _innerdatabaseclass = Innerdatabaseclass();
  late Future CheckMyLoc;

  List<dynamic> throwDetail = [];

  bool status = false;

  var callingcount = 0;

  @override
  void initState() {
    super.initState();
    CheckMyLoc = CheckKakaoMapMyLatLng().CheckMyLocation();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _playAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CheckMyLoc,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return AnimatedBuilder(
              builder: (context, child) {
                final double animationValue = curve.transform(_controller.value);
                return FractionalTranslation(
                  translation: Offset(0, -(1 - animationValue)),
                  child: child,
                );
              },
              animation: _controller,
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 80, 70, 0),
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Stack(
                        children: [
                          if(callingcount == 0)...{
                            FutureBuilder(
                                future: _searchInFo.Search(widget.SearchKeyword, LatLng(snapshot.data!.longitude, snapshot.data!.latitude)),
                                builder: (context, snapshot) {
                                  callingcount++;
                                  if(snapshot.hasData) {
                                    if(snapshot.data!.isEmpty) {
                                      return SafeArea(
                                          child: Container(
                                            width: double.infinity,
                                            height: 500,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                            decoration: BoxDecoration(
                                              color: Color(0xffffffff),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const DefaultTextStyle(
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff000000),
                                                fontFamily: 'omyu_pretty',
                                                fontSize: 20
                                              ),
                                              child: Text("검색 결과가 없습니다."),
                                            ),
                                          )
                                      );
                                    }
                                    else {
                                      return SafeArea(
                                          child: Container(
                                            width: double.infinity,
                                            height: 500,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                            decoration: BoxDecoration(
                                              color: Color(0xffffffff),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: ListView.builder(
                                              itemCount: snapshot.data?[0].length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Container(
                                                  child: GestureDetector(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: double.infinity,
                                                          height: 100,
                                                          margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                                          decoration: BoxDecoration(
                                                              color: const Color(0xffffffff),
                                                              borderRadius: BorderRadius.circular(20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.grey.withOpacity(0.2),
                                                                    spreadRadius: 5,
                                                                    blurRadius: 7,
                                                                    offset: const Offset(0, 3)
                                                                )
                                                              ]
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                width: 300,
                                                                margin: const EdgeInsets.fromLTRB(20, 17, 10, 10),
                                                                child: DefaultTextStyle(
                                                                  style: const TextStyle(fontSize: 25, color: Color(0xff000000), fontFamily: "omyu_pretty"),
                                                                  child:((){
                                                                    if(snapshot.data![0].elementAt(index).place_name!.length >= 13) {
                                                                      var beforedata = snapshot.data![0].elementAt(index).place_name!.split("");
                                                                      var middledata = [];
                                                                      for(int i = 0; i<12; i++) {
                                                                        middledata.add(beforedata[i]);
                                                                      }
                                                                      middledata.add("...");
                                                                      var afterdata = middledata.join();
                                                                      return Text("${afterdata}");
                                                                    } else {
                                                                      return Text("${snapshot.data![0].elementAt(index).place_name}");
                                                                    }
                                                                  })(),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 200,
                                                                margin: EdgeInsets.fromLTRB(20, 45, 10, 10),
                                                                child: DefaultTextStyle(
                                                                    style: const TextStyle(fontSize: 15, color: Color(0x88000000), fontFamily: "omyu_pretty"),
                                                                    child: Text("${snapshot.data![0].elementAt(index).address_name}",
                                                                    ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 200,
                                                                margin: const EdgeInsets.fromLTRB(20, 60, 10, 10),
                                                                child: DefaultTextStyle(
                                                                    style: const TextStyle(fontSize: 15,color: Color(0x88000000), fontFamily: "omyu_pretty"),
                                                                    child: Text("${snapshot.data![0].elementAt(index).category_group_name}")
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.fromLTRB(150, 0, 0, 0),
                                                                alignment: Alignment.center,
                                                                child: Image.asset(
                                                                  width: 40,
                                                                  height: 40,
                                                                  "assets/iconFile/phone.png",
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      removeoverlay();
                                                      throwDetail.clear();
                                                      _innerdatabaseclass.database;
                                                      await _innerdatabaseclass.insert(
                                                          Searchdbdatamodel(
                                                            name: snapshot.data![0][index].place_name.toString(),
                                                            category: snapshot.data![0][index].category_group_name.toString(),
                                                            phone: snapshot.data![0][index].phone.toString(),
                                                            address_name: snapshot.data![0][index].address_name.toString(),
                                                            road_address_name: snapshot.data![0][index].road_address_name.toString(),
                                                            place_url: snapshot.data![0][index].place_url.toString(),
                                                            x: snapshot.data![0][index].x.toString(),
                                                            y: snapshot.data![0][index].y.toString()
                                                          ));
                                                      throwDetail.add(snapshot.data![0][index].place_name);
                                                      throwDetail.add(snapshot.data![0][index].category_group_name);
                                                      throwDetail.add(snapshot.data![0][index].address_name);
                                                      throwDetail.add(snapshot.data![0][index].road_address_name);
                                                      throwDetail.add(snapshot.data![0][index].phone);
                                                      throwDetail.add(snapshot.data![0][index].place_url);
                                                      throwDetail.add(snapshot.data![0][index].x);
                                                      throwDetail.add(snapshot.data![0][index].y);
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) => ResturantDetail(name: throwDetail)
                                                          )
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                      );
                                    }
                                  }
                                  else if(snapshot.hasError) {
                                    return Container(
                                      width: double.infinity,
                                      height: 500,
                                      margin: EdgeInsets.fromLTRB(10, 100, 70, 80),
                                      color: Color(0xffffffff),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const DefaultTextStyle(
                                        style: TextStyle(
                                            color: Color(0xff000000),
                                            fontFamily: 'omyu_pretty',
                                            fontSize: 20
                                        ),
                                        child: Text("검색결과가 존재하지 않습니다."),
                                      ),
                                    );
                                  }
                                  else {
                                    return Container(
                                      width: double.infinity,
                                      height: 100,
                                      margin: EdgeInsets.fromLTRB(10, 100, 70, 80),
                                      color: Color(0xffffffff),
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }
                            ),
                          },
                        ],
                      ),
                    ),
                  ],
                )
              ),
            );
          }
          else if(snapshot.hasError) {
            return Container(
              width: double.infinity,
              height: 500,
              margin: EdgeInsets.fromLTRB(10, 100, 70, 80),
              color: const Color(0xffffffff),
              alignment: Alignment.center,
              child: const DefaultTextStyle(
                style: TextStyle(color: Color(0xff000000), fontFamily: 'omyu_pretty'),
                child: Text("주변 위치가 잘못 설정되었거나 주변에 /n 음식점이 존재하지 않을 수 있습니다."),
              ),
            );
          }
          else {
            return Container(
              width: double.infinity,
              height: 500,
              margin: EdgeInsets.fromLTRB(20, 150, 80, 200),
              color: const Color(0xffffffff),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
        }
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() async {
    await _controller.forward();
  }

  void removeoverlay() async {
    await _controller.reverse(from: 1);
    widget.onBannerDismissed!.call;
  }
}
