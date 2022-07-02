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
      required this.status});
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  DateTime createdAt;
  String status;
  String userBought;
  String authorId;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      userBought: json['userBought'] ?? '',
      authorId: json['authorId'] ?? '',
      status: json['status'] ?? '');

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
