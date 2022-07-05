class CreateProduct {
  CreateProduct(
      {required this.name,
      required this.description,
      required this.price,
      this.categoryId,
      this.postId,
      this.categoryName});
  String name;
  String description;
  int price;
  String? categoryId;
  String? postId;
  String? categoryName;
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'categoryId': categoryId,
        'postId': postId
      };
}
