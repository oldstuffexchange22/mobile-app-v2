class Category {
  Category(
      {required this.id,
      required this.name,
      this.parentId,
      this.categoriesChildren});
  String id;
  String name;
  String? parentId;
  List<Category>? categoriesChildren;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      parentId: json['parentId'] ?? '',
      categoriesChildren: (json['categoriesChildren'] as List)
          .map((e) => Category.fromJson(e))
          .toList());

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'parentId': parentId};
}
