import 'dart:convert';

import 'package:old_stuff_exchange/model/entity/product.dart';
import 'package:old_stuff_exchange/model/request/product_create.dart';

class CreatePost {
  CreatePost(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.authorId,
      required this.products});
  String id;
  String title;
  String description;
  String imageUrl;
  String authorId;
  String? postId;
  List<CreateProduct> products = [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'authorId': authorId,
        'products': products.map((e) => e.toJson()).toList()
      };
}
