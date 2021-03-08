import 'package:PhilosophyToday/screens/tools/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

Future saveUserData(FirebaseUser user) async{
  var box = await Hive.openBox("registeredUserData");
  Map userData ={"name":user.displayName,"email":user.email,"avatar":user.photoUrl};
  box.put("userData",userData);
  await box.close();
}
Future saveUserDataEM(String displayName, String email, String photoUrl) async{
  var box = await Hive.openBox("registeredUserData");
  Map userData ={"name":displayName,"email":email,"avatar":photoUrl};
  box.put("userData",userData);
  await box.close();
}
Future getUserImage() async{
  var box=await Hive.openBox("registeredUserData");
  Map data = box.get("userData");
  if (data["avatar"]==null){
    data["avatar"]="https://via.placeholder.com/150";
  }
  return data["avatar"];
}
Future getUserName() async{
  var box=await Hive.openBox("registeredUserData");
  Map data = box.get("userData");
  if (data["name"]==null){
    data["name"]="Random User";
  }
  return data["name"];
}
void postViewed(String title,
    String featuredImage,String subtitle, String textData, String shortLink,
    String tags, String category, String authorName, String authorEmail,
    String authorImage, String authorDescription,) async {
  try{
    var box = await Hive.openBox("websiteData");
    var oldData=box.get("websiteData");
    if (oldData is Map){
      if (oldData==null){
        await box.put("websiteData",[]);
      }else{
        await box.put("websiteData",[oldData]);
      }
    }
    if (oldData==null){
      await box.put("websiteData",[]);
    }
    eprint(oldData);
    List oldData2 = box.get("websiteData");
    eprint(oldData2);
    Map data={
      "title":title,
      "featuredImage":featuredImage,"subtitle":subtitle, "textData":textData, "shortLink":shortLink,
      "tags":tags, "category":category, "authorName":authorName, "authorEmail":authorEmail,
      "authorImage":authorImage, "authorDescription":authorDescription,
    };
    oldData2.add(data);
    await box.put("viewedPostData",oldData2);
  }catch(e){
    debugPrint(e.toString());
  }
}