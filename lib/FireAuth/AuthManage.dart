import 'package:firebase_auth/firebase_auth.dart';
import 'package:try_to_eat/AlertMessageFiles/ToastMessage.dart';

class AuthManage{

  String? _verificationId;

  ToastMessage toastMessage = ToastMessage();

  Future<bool> createUser(String email, String pass) async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
      print('try');
    } on FirebaseAuthException catch (e) {
      print(e.message);
      print('catch1');
      if (e.code == 'weak-password') {
        print('비밀번호가 너무 짧습니다.');
      } else if (e.code == 'email-already-in-use') {
        print('이미 존재하는 계정입니다.');
      }
    } catch (e) {
      print('catch2');
      print(e);
      return false;
    }
    return true;
  }

  //로그인
  Future<bool> Login(String email, String pass) async {
    try {
      final signinwithEmailpass = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if(e.code == "user-not-found") {
        toastMessage.toastMessageMethod("유저 정보가 없습니다.");
      } else if(e.code == "wrong-password") {
        toastMessage.toastMessageMethod("이메일 혹은 비밀번호를 다시 확인해주세요.");
      } else if(e.code == "INVALID_LOGIN_CREDENTIALS") {
        toastMessage.toastMessageMethod("이메일 혹은 비밀번호를 다시 확인해주세요.");
      }  else if(e.code == "invalid-email") {
        toastMessage.toastMessageMethod("이메일 형식이 올바르지 않습니다.");
      } else if(e.code == "too-many-requests") {
        toastMessage.toastMessageMethod("시도 횟수가 너무 많습니다.");
      }
      return false;
    } catch(e) {
      print(e);
      return true;
    }
    return true;
  }

  Future<bool> checkLoginStatus() async {
    bool Status = true;
    final checkLogin = await FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
          if(user != null) {
            Status = true;
          } else {
            Status = false;
          }
    });
    return Status;
  }
}