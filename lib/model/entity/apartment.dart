class Apartment {
  Apartment(
      {required this.id,
      required this.name,
      this.description,
      this.address,
      this.imageUrl});
  String id;
  String name;
  String? description;
  String? address;
  String? imageUrl;

  factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'] ?? '');

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'address': address,
        'imageUrl': imageUrl
      };
}
