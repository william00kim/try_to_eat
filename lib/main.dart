import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:try_to_eat/UserInterface/ImageSettingPage.dart';
import 'package:try_to_eat/UserInterface/LoginPage.dart';
import 'package:try_to_eat/UserInterface/HomePage.dart';
import 'package:try_to_eat/firebase_options.dart';

import 'UserInterface/CreateAccount.dart';
import 'UserInterface/MyPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "try_to_eat",
    options: DefaultFirebaseOptions.currentPlatform
  );
  AuthRepository.initialize(appKey: "7253dc7e63c9ef98ef50871f0a023cfd");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp (
        initialRoute: '/homepage',
        routes: {
          '/login': (context) => LoginPage(),
          '/homepage': (context) => const HomePage(),
          '/Mypage': (context) => const Mypage(),
          '/CreateAccount' : (context) => const CreateAccount(),
          '/ImageSetting' : (context) => const Imagesettingpage(),
        }
    );
  }
}
