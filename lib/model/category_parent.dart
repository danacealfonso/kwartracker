import 'category_model.dart';

class CategoryParent {
  CategoryParent(this.id, this.name, this.icon, this.parentID, this.child);

  final String id;
  final String name;
  final Map<String, dynamic> icon;
  final String parentID;
  final List<CategoryModel> child;
}
