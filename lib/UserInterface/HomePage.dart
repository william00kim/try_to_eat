import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:try_to_eat/AnimationBanner/SearchBanner.dart';
import 'package:try_to_eat/InnerDatabase/InnerDatabaseClass.dart';
import 'package:try_to_eat/InnerDatabase/SearchDBDataModel.dart';
import 'package:try_to_eat/Map/KakaoMap/CheckKakaoMapMyLatLng.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:try_to_eat/Map/KakaoMapRestAPI/SearchInFo.dart';
import 'package:try_to_eat/Map/KakaoMapRestAPI/SearchInFoResListParse.dart';

import 'RestaurantDetail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  late KakaoMapController mapController;
  late Future CheckLocPer;
  late Future CheckMyLoc;
  late Future SearchNear;
  late Future GetDatabase;
  bool ContainerAnimated = false;

  final TextEditingController _PlaceType = TextEditingController();
  final Innerdatabaseclass _innerdatabaseclass = Innerdatabaseclass();

  Set<Marker> markers = {};

  int current = 0;
  var Lng = 0.0;
  var Lat = 0.0;
  final List<String> entries = <String>["최근에 갔던 곳은 너무 좋았다..", "여기는 맛이 없다.."];
  List<List<SearchInFoResListParse>> getResult = [];
  List<List<SearchInFoResListParse>> NearbyResult = [];
  List<dynamic> throwDetail = [];
  List<List<Searchdbdatamodel>> PastSearchList = [];
  OverlayEntry? _bannerOverlay;

  Future<void> SetMyLatLng() async {
    Future.delayed(const Duration(seconds: 2));
    LatLng MyLoc = await CheckMyLoc;
    setState(() {
      Lat = MyLoc.latitude;
      Lng = MyLoc.longitude;
      SearchNear = SearchInFo().SearchNearbyRes(LatLng(Lat, Lng));
      print("설정에서 위도: $Lat");
      print("설정에서 위도: $Lng");
    });
  }

  @override
  void initState() {
    super.initState();
    CheckLocPer = CheckKakaoMapMyLatLng().CheckMapPermission();
    CheckMyLoc = CheckKakaoMapMyLatLng().CheckMyLocation();
    GetDatabase = Innerdatabaseclass().getDB();
    SetMyLatLng();
    setState(() {
      _innerdatabaseclass.getDB();
    });
    removeOverlay();
  }


  @override
  Widget build(BuildContext context) {
    PastSearchList.clear();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            // title: Container(
            //     alignment: Alignment.center,
            //     child: Text("먹깨비")
            // ),
            // titleTextStyle: TextStyle(color: Color(0xffffffff), fontFamily: "Light_font", fontSize: 15),
            backgroundColor: Color(0xffffa500),
          ),
        ),
        body: FutureBuilder(
              future: CheckMyLoc,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return <Widget>[
                    Center(
                      child: Container(
                        color: Color(0xffffa500),
                        width: double.infinity,
                        child: SingleChildScrollView(
                            child: Stack(
                              children: [
                                Container( //맨 위 먹어랑
                                  width: double.infinity,
                                  height: 80,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffffa500),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25)
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(30, 10, 10, 10),
                                    child: Text("먹어랑", style: TextStyle(color: Color(0xffffffff), fontSize: 30, fontFamily: 'omyu_pretty'),),
                                  ),
                                ),
                                Container( //최근에 쓴 리뷰
                                    width: double.infinity,
                                    height: 200,
                                    margin: EdgeInsets.fromLTRB(20, 70, 20, 10),
                                    decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3)
                                          )
                                        ]
                                    ),
                                    child: Stack(
                                      alignment: Alignment.topLeft,
                                      children: [
                                        //내가 쓴 리뷰 구현 안됨
                                        Container(
                                          width: 200,
                                          margin: const EdgeInsets.fromLTRB(20, 25, 10, 10),
                                          child: const Text("내가 쓴 리뷰", style: TextStyle(color: Color(0xffffa500), fontFamily: 'omyu_pretty', fontSize: 25),),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(30, 65, 30, 10),
                                          child: ListView.builder( //실시간 인기 리뷰
                                              itemCount: entries.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Container(
                                                  alignment: Alignment.centerLeft,
                                                  height: 25,
                                                  // child: Text("${entries[index]}"),
                                                  child: Text("${entries[index].toString()}", style: TextStyle(color: Colors.black54, fontFamily: 'omyu_pretty', fontSize: 15),),
                                                );
                                              }
                                          ),
                                        )
                                      ],
                                    )
                                ),
                                Container( //내 주변 맛집 탐색
                                    width: double.infinity,
                                    height: 200,
                                    margin: const EdgeInsets.fromLTRB(20, 300, 20, 10),
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
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Container(
                                            width: 200,
                                            margin: const EdgeInsets.fromLTRB(30, 25, 10, 10),
                                            child: const Text("내 주변 맛집", style: TextStyle(color: Color(0xffffa500), fontFamily: 'omyu_pretty', fontSize: 25),),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.fromLTRB(30, 40, 30, 10),
                                              alignment: Alignment.center,
                                              child: FutureBuilder(
                                                future: SearchNear,
                                                builder: (context, SearchValue) {
                                                  if(SearchValue.hasData) {
                                                    if(SearchValue.data!.length != 0) {
                                                      return ListView.builder(
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount: SearchValue.data!.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            return Container(
                                                                  alignment: Alignment.center,
                                                                  width: 80,
                                                                  height: 50,
                                                                  margin: const EdgeInsets.fromLTRB(0, 10, 15, 15),
                                                                  child: Column(
                                                                    children: [
                                                                      if(SearchValue.data![0][index].category_group_name == "카페")...{
                                                                        Container(
                                                                          margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                                                          child: Image.asset(
                                                                            "assets/iconFile/coffee.png",
                                                                            width: 70,
                                                                            height: 70,
                                                                          ),
                                                                        ),
                                                                      } else if(SearchValue.data![0][index].category_group_name == "음식점") ...{
                                                                        Container(
                                                                          margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                                                          child: Image.asset(
                                                                            "assets/iconFile/food-tray.png",
                                                                            width: 70,
                                                                            height: 70,
                                                                          ),
                                                                        ),
                                                                      } else ...{
                                                                        Container(
                                                                          margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                                                          child: Image.asset(
                                                                            "assets/iconFile/maps-and-flags.png",
                                                                            width: 70,
                                                                            height: 70,
                                                                          ),
                                                                        ),
                                                                      },
                                                                      Container(
                                                                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                          child: Text("${SearchValue.data![0][index].place_name}", style: const TextStyle(color: Color(0xff000000), fontFamily: 'omyu_pretty', fontSize: 14),)
                                                                      ),
                                                                    ],
                                                                  )
                                                            );
                                                          }
                                                      );
                                                    } else {
                                                      return Container(
                                                        width: double.infinity,
                                                        height: 180,
                                                        color: Color(0xffffffff),
                                                        alignment: Alignment.center,
                                                        child: const Text("주변에 음식점이 존재하지 않습니다.", style: TextStyle(fontFamily: 'omyu_pretty'),),
                                                      );
                                                    }
                                                  } else if(SearchValue.hasError) {
                                                    return Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      color: Color(0xffffffff),
                                                      alignment: Alignment.center,
                                                      child: Text("오류발생: ${SearchValue.error}"),
                                                    );
                                                  } else {
                                                    return Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      color: Color(0xffffffff),
                                                      alignment: Alignment.center,
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                },
                                              )
                                          ),
                                        ])
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  margin: const EdgeInsets.fromLTRB(20, 580, 20, 10),
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
                                )
                              ],
                            )
                        ),
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xff2f343d)
                        ),
                        child: Stack(
                          children: [
                            KakaoMapWidget(LatLng(Lat, Lng)),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.fromLTRB(20, 10, 70, 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3)
                                    )
                                  ]
                              ),
                              child: SearchBoxWidget(),
                            ),
                          ],
                        )
                    ),
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Color(0xffffffff),
                        child: Stack(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(20, 10, 70, 10),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3)
                                      )
                                    ]
                                ),
                                child: SearchBoxWidget()
                            ),
                            Container(
                                height: 300,
                                margin: const EdgeInsets.fromLTRB(20, 100, 70, 10),
                                decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3)
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: FutureBuilder(
                                  future: GetDatabase,
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData) {
                                      PastSearchList.clear();
                                      int gill_e = snapshot.data!.length;
                                      print(gill_e);
                                      if(gill_e != 0) {
                                        for(int i = gill_e - 1; i >= 0; i--) {
                                          PastSearchList.add([
                                            Searchdbdatamodel(
                                                name: snapshot.data!.elementAt(i).name.toString(),
                                                category: snapshot.data!.elementAt(i).category.toString(),
                                                phone: snapshot.data!.elementAt(i).phone.toString(),
                                                address_name: snapshot.data!.elementAt(i).address_name.toString(),
                                                road_address_name: snapshot.data!.elementAt(i).road_address_name.toString(),
                                                place_url: snapshot.data!.elementAt(i).toString(),
                                                x: snapshot.data!.elementAt(i).x.toString(),
                                                y: snapshot.data!.elementAt(i).y.toString()
                                            )
                                          ]);
                                        }
                                        return ListView.builder(
                                            padding: EdgeInsets.all(10),
                                            itemCount: PastSearchList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                alignment: Alignment.topCenter,
                                                child: GestureDetector(
                                                  child: Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                      decoration: BoxDecoration(
                                                          color: Color(0xffffffff),
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.grey.withOpacity(0.2),
                                                                spreadRadius: 5,
                                                                blurRadius: 10,
                                                                offset: const Offset(0, 3)
                                                            )
                                                          ]
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                            child: Text(PastSearchList[PastSearchList.length - index - 1][0].name.toString(),style: const TextStyle(color: Color(0xff000000), fontFamily: "omyu_pretty", fontSize: 25)),
                                                          ),
                                                          if(PastSearchList[PastSearchList.length - index - 1][0].category.toString() == "카페")... {
                                                            Container(
                                                              margin: EdgeInsets.fromLTRB(150, 10, 10, 10),
                                                              child: Image.asset(
                                                                "assets/iconFile/coffee.png",
                                                                width: 70,
                                                                height: 70,
                                                              ),
                                                            )
                                                          }
                                                          else if(PastSearchList[PastSearchList.length - index - 1][0].category.toString() == "음식 =")... {
                                                            Container(
                                                              margin: EdgeInsets.fromLTRB(150, 10, 10, 10),
                                                              child: Image.asset(
                                                                "assets/iconFile/food-tray.png",
                                                                width: 70,
                                                                height: 70,
                                                              ),
                                                            )
                                                          }
                                                          else ... {
                                                              Container(
                                                                margin: EdgeInsets.fromLTRB(150, 10, 10, 10),
                                                                child: Image.asset(
                                                                  "assets/iconFile/maps-and-flags.png",
                                                                  width: 70,
                                                                  height: 70,
                                                                ),
                                                              )
                                                            },
                                                        ],
                                                      )
                                                  ),
                                                  onTap: () {
                                                    throwDetail.clear();
                                                    throwDetail.add(snapshot.data![index].name);
                                                    throwDetail.add(snapshot.data![index].category);
                                                    throwDetail.add(snapshot.data![index].address_name);
                                                    throwDetail.add(snapshot.data![index].road_address_name);
                                                    throwDetail.add(snapshot.data![index].phone);
                                                    throwDetail.add(snapshot.data![index].place_url);
                                                    throwDetail.add(snapshot.data![index].x);
                                                    throwDetail.add(snapshot.data![index].y);
                                                    print("넘어가기 전: ${throwDetail}");
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) => ResturantDetail(name: throwDetail)
                                                        )
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                        );
                                      }
                                      else {
                                        return Container(
                                          width: double.infinity,
                                          height: 100,
                                          alignment: Alignment.center,
                                          child: const Text("맛집 검색을 통해 기록을 채워주세요!", style: TextStyle(fontFamily: "omyu_pretty", fontSize: 25)),
                                        );
                                      }
                                    }
                                    else {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        child: const Text("알 수 없는 오류로 인해 로드할 수 없습니다.", style: TextStyle(fontFamily: "omyu_pretty", fontSize: 25)),
                                      );
                                    }
                                  },
                                )
                            )
                          ],
                        )
                    ),
                  ][current];
                }
                else if(snapshot.hasError) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Color(0xffffffff),
                    alignment: Alignment.center,
                    child: Text("오류발생: ${snapshot.error}"),
                  );
                }
                else {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Color(0xffffffff),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              }
          ),
        floatingActionButton: floatingBtn(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        bottomNavigationBar: BottomAppBar(
            height: 45,
            color: Color(0xffffa500),
            child: IconTheme(
                data: IconThemeData(color: Color(0xffffffff)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    IconButton(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        onPressed: () {
                          removeOverlay();
                          setState(() {
                            current = 0;
                          });},
                        icon: const Icon(Icons.home, color: Color(0xffffffff), size: 25,)
                    ),
                    IconButton(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        onPressed: () async {
                          setState(() {
                            current = 1;
                          });
                        },
                        icon: const Icon(Icons.pin_drop_outlined, color: Color(0xffffffff), size: 25)
                    ),
                    IconButton(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        onPressed: () {
                          removeOverlay();
                          setState(() {
                            current = 2;
                          });},
                        icon: const Icon(Icons.search, color: Color(0xffffffff),size: 25)
                    ),
                  ],
                )
            )
        )
    );
  }

  Widget? floatingBtn() {
    if(current == 1 || current == 2) {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          width: 50,
          height: 50,
          alignment: Alignment.centerRight,
          child: SpeedDial(
            animatedIcon: AnimatedIcons.ellipsis_search,
            animatedIconTheme: IconThemeData(color: Colors.white),
            curve: Curves.decelerate,
            backgroundColor: Color(0xffffa500),
            direction: SpeedDialDirection.down,
            children: [
              SpeedDialChild(
                  child: const Icon(
                    Icons.people_alt_outlined,
                    color: Colors.white,
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  backgroundColor: Color(0xffffa500),
                  onTap: () {
                    removeOverlay();
                    Navigator.pushNamed(context, '/Mypage');
                  }),
              SpeedDialChild(
                  child: const Icon(
                    Icons.key_rounded,
                    color: Colors.white,
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  backgroundColor: Color(0xffffa500),
                  onTap: () {
                    removeOverlay();
                    Navigator.pushNamed(context, '/login');
                  }),
              // SpeedDialChild(
              //     child: const Icon(
              //       Icons.photo,
              //       color: Colors.white,
              //     ),
              //     labelStyle: const TextStyle(
              //       fontWeight: FontWeight.w500,
              //       color: Colors.white,
              //       fontSize: 20.0,
              //     ),
              //     backgroundColor: Color(0xffffa500),
              //     onTap: () {
              //       removeOverlay();
              //       Navigator.pushNamed(context, '/ImageSetting');
              //     }),
              SpeedDialChild(
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  backgroundColor: Color(0xffffa500),
                  onTap: () {
                    _innerdatabaseclass.deleteAllDB();
                  }),
            ],
          )
      );
    } else {
      return null;
    }
  }

  Widget KakaoMapWidget(LatLng ps) {
    return KakaoMap(
      onMapCreated: ((controller) {
        mapController = controller;
        markers.add(Marker(markerId: "내 위치", latLng: LatLng(ps.latitude, ps.longitude)));
        setState(() { });

      }),
      onMapTap: (latLng) {

      },
      center: LatLng(ps.latitude, ps.longitude),
      clusterer: Clusterer(markers: markers.toList()),
    );
  }

  Widget SearchBoxWidget() {
    return Container(
      child: TextField( //장소 검색
        controller: _PlaceType,
        style: const TextStyle(
            height: 2.3
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Color(0xffffffff),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffffffff),
              style: BorderStyle.solid,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color(0xffffffff),
                style: BorderStyle.solid
            ),
          ),
          suffixIcon: IconButton(
            alignment: Alignment.center,
            onPressed:() {
              _PlaceType.text = "";
              removeOverlay();
            },
            icon: Icon(Icons.clear),
          ),
        ),
        onChanged: (value) async {
          value = _PlaceType.text;
          print(value);
          if(value == null) {
            removeOverlay();
          }
        },
        onSubmitted: (value) async {
          if(value.isNotEmpty) {
            displayOverlay(value);
          } else if(value.isEmpty || value == " " || value.length == 0 || value == "에러: null") {
            removeOverlay();
          }
        },
      ),
    );
  }

  void displayOverlay(String name) {
    WidgetsBinding.instance.addPostFrameCallback((_) => SearchBanner(name));
  }

  void SearchBanner(String Keyword) {
    _bannerOverlay = OverlayEntry(
      builder: (context) {
        return Searchbanner(
          SearchKeyword: Keyword,
          onBannerDismissed: () {
            removeOverlay();
          },
        );
      },
    );
    final overlay = Overlay.of(context);
    overlay.insert(_bannerOverlay!);
  }

  void removeOverlay() {
    getResult.clear();
    _bannerOverlay?.remove();
    _bannerOverlay?.dispose();
    _bannerOverlay = null;
  }

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

}