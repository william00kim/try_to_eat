import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:try_to_eat/FirebaseCloudFunctions/CloudFunctionsCodes.dart';
import 'package:try_to_eat/FirebaseCloudFunctions/CloudfunctionsJsonParse.dart';

class ResturantDetail extends StatefulWidget {
  const ResturantDetail({super.key, required this.name});
  final List<dynamic> name;
  @override
  State<ResturantDetail> createState() => _ResturantDetailState();
}

class _ResturantDetailState extends State<ResturantDetail> {


  late KakaoMapController mapController;

  Set<Marker> markers = {};

  late Future valuableofcloud;

  @override
  void initState() {
    valuableofcloud = Cloudfunctionscodes().ImageAndTimeStamp(widget.name.elementAt(5).toString());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("넘어간 후 : ${widget.name}");
    return Scaffold(
      appBar: AppBar(
        title: Row(
            children:[Text(widget.name.elementAt(0).toString())] //음식점 이름
        ),
        titleTextStyle: const TextStyle(color: Color(0xffffffff), fontFamily: "omyu_pretty", fontSize: 20),
        backgroundColor: const Color(0xffffa500),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                width: double.infinity,
                child: KakaoMap(
                  currentLevel: 1,
                  onMapCreated: ((controller) {
                    mapController = controller;
                    markers.add(Marker(markerId: "위치", latLng: LatLng(double.parse(widget.name.elementAt(7)), double.parse(widget.name.elementAt(6)))));
                    setState(() {
                    });
                  }),
                  center: LatLng(double.parse(widget.name.elementAt(7)) - 0.0005, double.parse(widget.name.elementAt(6))),
                  clusterer: Clusterer(markers: markers.toList()),
                )
            ),
            SlidingUpPanel(
              renderPanelSheet: false,
              defaultPanelState: PanelState.OPEN,
              collapsed: SizedBox(
                width: 200,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                          color: Color(0xffffa500),
                          border: Border.all(color: Colors.white),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)
                          )
                      ),
                      child: Text(widget.name.elementAtOrNull(0), style: TextStyle(fontFamily: 'omyu_pretty', fontSize: 20, color: Color(0xffffffff)),),
                    ),
                    Container(
                      width: double.infinity,
                      height: 30,
                      alignment: Alignment.center,
                      child: Icon(Icons.remove, color: Color(0xffffffff), weight: 20,),
                    )
                  ],
                ),
              ),
              panel: Container(
                  width: double.infinity,
                  height: 100,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1)
                        )
                      ],
                      border: Border.all(color: Colors.white, width: 10),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                      )
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container( //장소 이름
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          alignment: Alignment.center,
                          child: Text(widget.name.elementAt(0), style: TextStyle(fontSize: 30, fontFamily: 'omyu_pretty'),),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Divider(
                            height: 10,
                          ),
                        ),
                        Container( //기능
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: IconButton(
                                    onPressed: () {

                                    },
                                    icon: Image.asset(
                                      "assets/iconFile/maps-and-flags.png",
                                      width: 30,
                                      height: 30,
                                    )
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: IconButton(
                                    onPressed: () {

                                    },
                                    icon: Image.asset(
                                      "assets/iconFile/phone.png",
                                      width: 30,
                                      height: 30,
                                    )
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: IconButton(
                                    onPressed: () {

                                    },
                                    icon: const Icon(
                                      Icons.bookmark,
                                      size: 35,
                                      color: Color(0xffffa500),
                                    )
                                ),
                              ),
                            ]
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: const Divider(
                            height: 10,
                          ),
                        ),
                        SingleChildScrollView(
                          child: Stack(
                            children: [
                              Container( //주소
                                  margin: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(widget.name.elementAt(2), style: TextStyle(fontSize: 25, fontFamily: 'omyu_pretty'),)
                              ),
                              Container( //도로명 주소
                                  margin: const EdgeInsets.fromLTRB(40, 45, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(" > " + widget.name.elementAt(3), style: TextStyle(fontSize: 18, fontFamily: 'omyu_pretty'),)
                              ),
                              if(widget.name.elementAt(4) != "")...{
                                Container( //전화번호
                                    margin: EdgeInsets.fromLTRB(30, 72, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child: Text("전화번호: ${widget.name.elementAt(4)}", style: TextStyle(fontSize: 23, fontFamily: 'omyu_pretty'),)
                                ),
                              } else ...{
                                Container( //전화번호
                                    margin: EdgeInsets.fromLTRB(30, 70, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child: Text("전화번호 정보가 없습니다.",style: TextStyle(fontSize: 15, fontFamily: 'omyu_pretty',color: Color(0xff7a7a7a)),)
                                ),
                              },
                              Container(
                                margin: EdgeInsets.fromLTRB(30, 105, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: FutureBuilder(
                                  future: valuableofcloud,
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData) {
                                      var preParse = snapshot.data;
                                      Cloudfunctionsjsonparse UseData = Cloudfunctionsjsonparse.fromJson(preParse);
                                      var ListOfTimeData = SplitStringFromData(UseData.Time);
                                      return Column(
                                        children: [
                                          if(UseData.Time ==  "정보 없음")...{
                                            Container(
                                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                alignment: Alignment.centerLeft,
                                                child: Text("시간 정보가 없습니다." ,style: TextStyle(fontSize: 15, fontFamily: 'omyu_pretty',color: Color(0xff7a7a7a)),)
                                            ),
                                          } else ...{
                                            for(int i = 0; i < ListOfTimeData.length; i++)...{
                                              //시간
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(ListOfTimeData[i].toString() ,style: TextStyle(fontSize: 23, fontFamily: 'omyu_pretty'),)
                                              ),
                                            },
                                          },
                                          if(UseData.ImageLink == "정보 없음")...{
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              width: 300,
                                              height: 300,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                "이미지가 없습니다.",
                                                style: TextStyle(fontSize: 15, fontFamily: 'omyu_pretty'),
                                              )
                                            ),
                                          } else ...{
                                            Container(
                                              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                              alignment: Alignment.centerLeft,
                                              child: Image.network(
                                                UseData.ImageLink,
                                                width: 300,
                                                height: 200,
                                              ) ,
                                            ),
                                          }
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return Container(
                                          width: 280,
                                          height: 200,
                                          color: Color.fromRGBO(255, 255, 255, 0),
                                          alignment: Alignment.center,
                                          child: DefaultTextStyle(
                                            style: const TextStyle(color: Color(0xff000000), fontFamily: 'omyu-pretty'),
                                            child: Text("오류가 발생했습니다. (${snapshot.error.toString()})"),
                                          )
                                      );
                                    } else {
                                      return Container(
                                        width: 280,
                                        height: 100,
                                        color: const Color(0xffffffff),
                                        alignment: Alignment.center,
                                        child: const CircularProgressIndicator(
                                          color: Color(0xff000000),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )

              ),
            )
          ],
        ),
      ),
    );
  }

  List<String> SplitStringFromData(String Data) {
    List<String> SplitData = Data.split("\n");
    List<String> deletedSplitData = [];
    print(SplitData);
    if(SplitData.length >= 3) {
      for(int i = 1; i < SplitData.length - 1; i++) {
        deletedSplitData.add(SplitData[i]);
      }
      return deletedSplitData;
    }
    return SplitData;
  }

}