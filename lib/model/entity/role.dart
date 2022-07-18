class Role {
  Role({required this.name, required this.id});
  String id;
  String name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'] ?? '',
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        "name": name,
      };
}
