import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try_to_eat/FireAuth/AuthManage.dart';
import 'package:try_to_eat/AlertMessageFiles/ToastMessage.dart';

class LoginPage extends StatelessWidget {

  LoginPage({super.key});

  late final FirebaseAuth auth;

  AuthManage authMange = AuthManage();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  ToastMessage toastMessage = ToastMessage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xffffa500),
            title: const Text("먹어랑"),
            titleTextStyle: const TextStyle(color: Color(0xffffffff), fontFamily: 'omyu_pretty', fontSize: 18)
        ),
        body: Center(
          child: Container(
            height: double.infinity,
            color: Color(0xffffffff),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  width: double.infinity,
                  height: 700,
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Stack(
                    children: [
                      Container( //로그인버튼
                        alignment: Alignment.center,
                        child: Container(
                          width: 280,
                          height: 90,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
                          child: TextButton(
                            onPressed: () async {
                              if(email.text == "" || password.text == "") {
                                toastMessage.toastMessageMethod("아이디와 비밀번호를 모두 입력해주세요.");
                              } else {
                                if(await authMange.Login(email.text, password.text) == true) {
                                  Navigator.popAndPushNamed(context, "/Mypage");
                                }
                              }
                            },
                            child: const Text("로그인", style: TextStyle(color: Color(0xffffffff), fontFamily: "omyu_pretty", fontSize: 18),),
                            style: TextButton.styleFrom(
                              elevation: 10,
                              shadowColor: Colors.black.withOpacity(0.3),
                              backgroundColor: Color(0xffffa500),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              alignment: Alignment.bottomCenter
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 450,
                        alignment: Alignment.center,
                        child: Stack(
                            children: [
                              Container( //로그인 박스
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
                                width: 300,
                                height: 250,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      )
                                    ]
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 40,
                                      margin: const EdgeInsets.fromLTRB(0, 50, 0, 15),
                                      child: TextField(
                                        keyboardType: TextInputType.emailAddress,
                                        controller: email,
                                        style: const TextStyle(
                                          fontFamily: 'omyu_pretty',
                                          fontSize: 18,
                                          height: 1
                                        ),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '아이디',
                                          labelStyle: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'omyu_pretty'
                                          )
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 40,
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                                      child: TextField(
                                        keyboardType: TextInputType.visiblePassword,
                                        controller: password,
                                        obscureText: true,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'omyu_pretty',
                                            height: 1
                                        ),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '비밀번호',
                                          labelStyle: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'omyu_pretty'
                                          )
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 40,
                                      // alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                                            child: TextButton(onPressed: () {},  child: Text("계정찾기", style: TextStyle(fontFamily: "omyu_pretty", color: Color(0xff000000), fontSize: 15),), style: TextButton.styleFrom(iconColor: Color(0xff000000)) ),
                                          ),
                                          Container(
                                            child: Text("|", style: TextStyle(fontFamily: "omyu_pretty", color: Color(0xff000000), fontSize: 18)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 70, 0),
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(context, '/CreateAccount');
                                                },
                                                child: Text("회원가입", style: TextStyle(fontFamily: "omyu_pretty", color: Color(0xff000000), fontSize: 15),),
                                                style: TextButton.styleFrom(iconColor: Color(0xff000000))
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        )
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 600),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("맛집을 찾아보자~~", style: TextStyle(color: Color(0xffffffff), fontSize: 18, fontFamily: "omyu_pretty"),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffffa500),
                            )
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height:  1,
                              color: Colors.black26,
                            ),
                            Container(
                              child: const Text("  (Or)  "),
                            ),
                            Container(
                              width: 120,
                              height: 1,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(120, 170, 0, 0),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: IconButton(
                                onPressed: () {
                                  toastMessage.toastMessageMethod("아직 카카오 로그인이 되지 않습니다.");
                                },
                                icon: Image.asset(
                                  "assets/iconFile/speech-bubble.png",
                                  width: 50,
                                  height: 50,
                                ),
                                // child: const Text("KaKao", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "omyu_pretty"),),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              decoration: BoxDecoration(
                                color: Color(0xff42d31d),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  toastMessage.toastMessageMethod("아직 네이버 로그인이 되지 않습니다.");
                                },
                                icon: Image.asset(
                                  "assets/iconFile/n.png",
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ),
          ),
        )
    );
  }
}