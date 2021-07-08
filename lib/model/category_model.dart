import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  CategoryModel(this.id, this.name, this.icon, this.parentID);

  final String id;
  final String name;
  final Map<String, dynamic> icon;
  final String parentID;
  Map<String, dynamic> asMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'phoneNumber': icon,
        'address': parentID,
      };
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phoneNumber': icon,
      'address': parentID,
    };
  }
}
