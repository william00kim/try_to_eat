
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try_to_eat/FireAuth/AuthManage.dart';

class Mypage extends StatefulWidget {

  const Mypage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<Mypage> {

  AuthManage authMange = AuthManage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
            children:[Text("flutter")]
        ),
        titleTextStyle: TextStyle(color: Color(0xffffa500), fontFamily: "Light_font", fontSize: 15),
        backgroundColor: Color(0xfffffffff),
      ),
      body: Container(
        child: FutureBuilder(
            future: authMange.checkLoginStatus(),
            builder: (context, snapshot) {
              print(snapshot.data);
              if(snapshot.hasData == null) {
                return falseColumn(context);
              } else if(snapshot.hasData == true){
                if(snapshot.data == true) {
                  return Container(
                    alignment: Alignment.center,
                    child: trueColumn(context),
                  );
                } else if(snapshot.data == false) {
                  return Container(
                    alignment: Alignment.center,
                    child: falseColumn(context),
                  );
                }
                return falseColumn(context);
              } else if(snapshot.hasData == false) {
                return falseColumn(context);
              } else {
                return Text("로딩중");
              }
            },
        )
      )
    );
  }

  Widget trueColumn(BuildContext diamond) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(20),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffffffff), width: 10),
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]
          ),
          child: Text("프로필 사진"),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffffffff), width: 10),
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffffffff), width: 10),
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffffffff), width: 10),
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffffffff), width: 10),
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]
          ),
          child: TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(diamond);
            },
            child: Text("로그아웃"),
          ),
        ),
      ],
    );
  }

  Widget falseColumn(BuildContext diamond) {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(20),
            width: 300,
            height: 200,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffffffff), width: 10),
                borderRadius: BorderRadius.circular(20),
                color: Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ]
            ),
            child: Column(
              children: [
                Container(
                  height: 140,
                  child: IconButton(onPressed: () {
                    Navigator.popAndPushNamed(diamond, "/login");
                  }, icon: Icon(Icons.people, color: Color(0xffffa500),)),
                ),
                Text("로그인이 필요한 서비스 입니다.", style: TextStyle(color: Color(0xffffa500), fontFamily: 'omyu_pretty', fontSize: 18),),
              ],
            )
        )
      ],
    );
  }
}