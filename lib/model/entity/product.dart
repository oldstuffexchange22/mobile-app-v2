class Product {
  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.status,
      required this.categoryId,
      required this.postId});
  String id;
  String name;
  String description;
  double price;
  String status;
  String categoryId;
  String postId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      status: json['status'] ?? '',
      categoryId: json['categoryId'] ?? '',
      postId: json['postId'] ?? '');

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'status': status,
        'categoryId': categoryId,
        'postId': postId
      };
}
