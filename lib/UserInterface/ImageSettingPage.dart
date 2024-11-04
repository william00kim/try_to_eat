import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Imagesettingpage extends StatefulWidget {
  const Imagesettingpage({super.key});

  @override
  State<Imagesettingpage> createState() => _ImagesettingpageState();
}

class _ImagesettingpageState extends State<Imagesettingpage> {

  bool ContainerAnimated = false;

  @override
  Widget build(BuildContext context) {
    
    ImagePicker imagePicker = ImagePicker();
    var imageSet;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffa500),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(255, 255, 255, 1),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if(imageSet == null)...{
              Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 300),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ]
                ),
                child: Text("판별할 이미지를 넣어주세요."),
              ),
              GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      child: TextButton(
                        child: Text("버튼을 눌러보세요"),
                        onPressed: () {
                          setState(() {
                            ContainerAnimated = !ContainerAnimated;
                          });
                        },
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 80),
                      curve: Curves.bounceInOut,
                      width: ContainerAnimated ? 330 : 0,
                      height: ContainerAnimated ? 330 : 0,
                      margin: EdgeInsets.fromLTRB(10, 100, 10, 100),
                      color: Color(0xffffffff),
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                height: 100,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(10),
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
                  onPressed: () async {
                    var setImage = await imagePicker.pickImage(source: ImageSource.gallery);
                    if(setImage != null) {
                      setState(() {
                        imageSet = File(setImage.path);
                      });
                    }
                  },
                  child: Text(" + 이미지를 넣으시려면 터치해주세요."),
                )
              ),
            }
            else ... {
              Container(
                width: 300,
                height: 300,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 300),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ]
                ),
                child: Image.file(
                  imageSet,
                  width: 300,
                  height: 300,
                ),
              ),
              Container(
                width: 300,
                height: 200,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(10),
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

                  },
                  child: Text(" + 이미지를 넣으시려면 터치해주세요."),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}

