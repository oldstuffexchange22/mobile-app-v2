import 'package:old_stuff_exchange/model/entity/product.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';

class Post {
  Post(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.createdAt,
      required this.userBought,
      required this.authorId,
      required this.author,
      required this.lastUpdatedAt,
      required this.status,
      required this.products});
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  DateTime createdAt;
  DateTime lastUpdatedAt;
  String status;
  String userBought;
  String authorId;
  User? author;
  List<Product> products = [];

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
      userBought: json['userBought'] ?? '',
      authorId: json['authorId'] ?? '',
      author: json['author'] == null ? null : User.fromJson(json['author']),
      status: json['status'] ?? '',
      products: (json['products'] as List).isEmpty
          ? []
          : (json['products'] as List)
              .map((p) => Product.fromJson(p))
              .toList());

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'createdAt': createdAt,
        'userBought': userBought,
        'authorId': authorId,
        'status': status
      };
}
