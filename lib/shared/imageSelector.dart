import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

bool imageSelected=false;

Future<PickedFile> profileImg;

class ImagePickerCustom extends StatefulWidget {
  @override
  _ImagePickerCustomState createState() => _ImagePickerCustomState();
}
String imageUrl="assets/images/user.png";
class _ImagePickerCustomState extends State<ImagePickerCustom> {
  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    return GestureDetector(
      onTap: ()async {
        profileImg = picker.getImage(source: ImageSource.gallery);
        profileImg.then((value) => print(value.path));
        if (profileImg!=null){
          profileImg.then((value) => imageUrl=value.path);
          imageSelected=true;
        }
        setState(() {
        });
      },
      child: Container(
        child: FutureBuilder(
          builder: (context, data) {
            if (data.hasData) {
              return Container(
                height: 150.0,
                width: 150,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: 20.0,
                          spreadRadius: 5.0,
                          offset: Offset(4,20)
                      )
                    ],
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(100)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Image.asset(
                    data.data.path,
                    fit: BoxFit.cover,
                    height: 200.0,
                  ),
                ),
              );
            }
            return Container(
              height: 150.0,
              width: 150.0,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400],
                    blurRadius: 20.0,
                    spreadRadius: 5.0,
                    offset: Offset(4,20)
                  )
                ],
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(100)
              ),
              child: Container(margin: EdgeInsets.all(20),child: Text("Please choose an image for your avatar",textAlign: TextAlign.center,)),
            );
          },
          future: profileImg,
        ),
      ),
    );
  }
}
