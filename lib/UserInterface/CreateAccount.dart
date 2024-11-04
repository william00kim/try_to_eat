
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:try_to_eat/FireAuth/AuthManage.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

enum Gender {Man, Woman, etc}

class _CreateAccountState extends State<CreateAccount> {

  AuthManage authManage = AuthManage();
  TextEditingController NickName = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController PasswordCheck = TextEditingController();
  DateTime date = DateTime.now();

  final _EmailCode = ["gmail.com", "naver.com", "hanmail.net", "daum.net"];
  String _SelectedEmailCode = "";
  String Id = "";
  int current = 0;
  final db = FirebaseFirestore.instance;
  int pressedcount = 0;

  @override
  void initState() {

    super.initState();
    _SelectedEmailCode = _EmailCode[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: Container(
        width: double.infinity,
        height: 100,
        color: Color(0xffffa500),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(0xffffa500))
          ),
          child: (() {
            if(current != 3) {
              return const Text("입력완료", style: TextStyle(color: Color(0xffffffff)),);
            } else {
              return const Text("완료", style: TextStyle(color: Color(0xffffffff)),);
            }
          }) (),
          onPressed: () async {
            if(pressedcount == 0) {
              if(current == 0) {
                if(Email.text == null || Email.text == "") {
                  Fluttertoast.showToast(
                      msg: "이메일을 입력하세요.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      fontSize: 14
                  );
                } else {
                  setState(() {
                    current += 1;
                  });
                }
              } else if(current == 1) {
                if(NickName.text == null || NickName.text == "") {
                  Fluttertoast.showToast(
                      msg: "닉네임을 입력하세요.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      fontSize: 14
                  );
                } else {
                  setState(() {
                    current += 1;
                  });
                }
              } else if(current == 2) {
                if(Password.text == null || Password.text == "") {
                  Fluttertoast.showToast(
                      msg: "비밀번호를 입력하세요.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      fontSize: 14
                  );
                } else if(Password.text != PasswordCheck.text) {
                  Fluttertoast.showToast(
                      msg: "비밀번호가 서로 다릅니다.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      fontSize: 14
                  );
                } else if(Password.text.length < 8) {
                  Fluttertoast.showToast(
                      msg: "비밀번호의 길이가 너무 짦습니다.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      fontSize: 14
                  );
                } else {
                  setState(() {
                    current += 1;
                  });
                }
              } else if (current == 3) {
                Id = "${Email.text.toString()}@${_SelectedEmailCode.toString()}";
                print("이메일: $Id, 비밀번호: ${Password.text.toString()}");
                if(await authManage.createUser(Id, Password.text) == true) {
                  pressedcount += 1;
                  final UserCreateData = <String, dynamic> {
                    "Id" : Id,
                    "NickName" : NickName.text,
                    "Birth" : date
                  };
                  db.collection("UserInfo").doc(Id).set(UserCreateData).then((value) {
                    print("데이터베이스에 추가 되었습니다. (추가된 곳: ${Id})");
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "회원가입완료",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        fontSize: 14
                    );
                  });
                }
              }
            } else {
              Fluttertoast.showToast(
                  msg: "잠시 기다려주세요.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  fontSize: 14
              );
            }
          },
        ),
      ),
      appBar: AppBar(
        title: const Text("회원가입"),
        centerTitle: false,
        titleTextStyle: const TextStyle(color: Color(0xffffffff), fontFamily: "Light_font", fontSize: 15),
        backgroundColor: Color(0xffffa500),
        elevation: 5,
        shadowColor: Colors.white,
      ),
      body: <Widget>[
        SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Container(
                        width: 330,
                        margin: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "이메일 :)",
                          style: TextStyle(
                            color: Color(0xffFFA500),
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            fontFamily:  'omyu_pretty',
                          ),
                        ),
                      ),
                      Container(
                        width: 330,
                        margin: const EdgeInsets.fromLTRB(30, 5, 10, 130),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "로그인시 입력하는 아이디 입니다.",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 20,
                            fontFamily:'omyu_pretty',
                          ),
                        ),
                      ),
                      Container(
                        width: 400,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 50,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: Email,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                    fontFamily: 'omyu_pretty',
                                    fontSize: 20,
                                ),
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffffa500),
                                      style: BorderStyle.solid
                                    )
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color(0xffffa500)
                                  ),
                                  // labelText: "이메일",
                                  hintText: "ExampleID",
                                  hintStyle: TextStyle(
                                      color: Colors.black12
                                  )
                                ),
                              ),
                            ),
                            Text("@"),
                            Container(
                              width: 150,
                              height: 100,
                              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              alignment: Alignment.bottomCenter,
                              child: DropdownButton(
                                value: _SelectedEmailCode,
                                items: _EmailCode.map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text("$e")
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _SelectedEmailCode = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
        ),
        SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                child: SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Container(
                        width: 330,
                        margin: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "닉네임 :)",
                          style: TextStyle(
                            color: Color(0xffffa500) ,
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            fontFamily:  'omyu_pretty',
                          ),
                        ),
                      ),
                      Container(
                        width: 330,
                        margin: const EdgeInsets.fromLTRB(30, 10, 10, 100),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "다른 이용자에게 표시되는 닉네임 입니다.",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize:20,
                            fontFamily:  'omyu_pretty',
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: NickName,
                          style: const TextStyle(
                              fontFamily: 'omyu_pretty',
                              height: 1
                          ),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffffa500),
                                      style: BorderStyle.solid
                                  )
                              ),
                              hintText: "먹깨비",
                              hintStyle: TextStyle(
                                  color: Colors.black12
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            )
        ),
        Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                child: Container(
                  height: 400,
                  child: Column(
                    children: [
                      Container(
                        width: 330,
                        margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "비밀번호 :)",
                          style: TextStyle(
                            color: Color(0xffffa500),
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            fontFamily:  'omyu_pretty',
                          ),
                        ),
                      ),
                      Container(
                        width: 330,
                        margin: const EdgeInsets.fromLTRB(30, 5, 10, 100),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "로그인시 입력하는 비밀번호 입니다.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:20,
                            fontFamily: 'omyu_pretty',
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: Password,
                          obscureText: true,
                          style: const TextStyle(
                            fontFamily: 'omyu_pretty',
                            fontSize: 20
                          ),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffffa500),
                                      style: BorderStyle.solid
                                  )
                              ),
                              hintText: "비밀번호",
                              hintStyle: TextStyle(
                                  color: Colors.black12
                              )
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          obscureText: true,
                          controller: PasswordCheck,
                          style: const TextStyle(
                              fontFamily: 'omyu_pretty',
                              fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffffa500),
                                      style: BorderStyle.solid
                                  )
                              ),
                              hintText: "비밀번호 확인",
                              hintStyle: TextStyle(
                                  color: Colors.black12
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            )
        ),
        Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                child: Container(
                  height: 400,
                  child: Column(
                    children: [
                      Container(
                        width: 330,
                        margin: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "생년월일 ;)",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'omyu_pretty',
                          ),
                        ),
                      ),
                      Container(
                        width: 330,
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xffFFFFFF)),
                            shadowColor: MaterialStatePropertyAll(Colors.black12),
                            elevation: MaterialStatePropertyAll(10),
                          ),
                          onPressed: () async {
                            final select = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now(),
                              initialEntryMode: DatePickerEntryMode.calendarOnly
                            );
                            if(select != null) {
                              setState(() {
                                date = select;
                              });
                            }
                          },
                          child: Text("$date"),
                        ),
                      ),
                      Container(
                        width: 330,
                        // alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(30, 20, 10, 10),
                        child: Text("↑ 클릭시 변경 가능", style: TextStyle(color: Color(0xffffa500)),),
                      )
                    ],
                  ),
                )
            )
        ),
        Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.greenAccent,Colors.blueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              ),
            ),
            child: SingleChildScrollView(
                child: Container(
                  height: 400,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 165,
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    current -= 1;
                                  });
                                },
                                label: const Text("이전"),
                                icon: const Icon(Icons.arrow_back_ios),
                              ),
                            ),
                            Container(
                              width: 165,
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {

                                  });
                                },
                                label: const Text("완료"),
                                icon: const Icon(Icons.check),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 330,
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "이메일을 입력해주세요. ;)",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            fontFamily:  'omyu_pretty',
                          ),
                        ),
                      ),
                      Container(
                        width: 330,
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 100),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "로그인시 입력하는 아이디 입니다.",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize:18,
                            fontFamily:  'omyu_pretty',
                          ),
                        ),
                      ),
                      Container(
                        width: 330,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: const TextField(
                          // controller: NickName,
                          style: TextStyle(
                              fontFamily: 'omyu_pretty',
                              height: 1
                          ),
                          decoration: InputDecoration(
                              hintText: "Example@Example.com",
                              hintStyle: TextStyle(
                                  color: Colors.black12
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            )
        ),
      ] [current]
    );
  }
}
