import 'package:hive/hive.dart';
import 'dart:convert' show json, jsonDecode;

int categoryToId(String category) {
  var box = Hive.box('myBox');
  List name = box.get('categories');
  for (int i=0; i < name.length; i++) {
    if (name[i]["name"].toString().toLowerCase() == category.toLowerCase()) {
      return name[i]["id"];
    }
  }
  return 0;
}
String tagToId(String tag) {
  var box = Hive.box('myBox');
  List name = box.get('tags');
  for (int i=0; i < name.length; i++) {
    if (name[i]["name"].toString().toLowerCase() == tag.toLowerCase()) {
      return name[i]["id"].toString();
    }
  }
  return '0';
}
String maxPost(){
  var box = Hive.box('myBox');
  String totalLength = box.get('postLength');
  return totalLength;
}
void eprint(data){
  print("============");
  print(data);
  print("============");
}
extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (this.length <= maxLength) ? this : '${this.substring(0, maxLength)}...';
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}