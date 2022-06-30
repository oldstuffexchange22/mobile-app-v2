class Building {
  Building(
      {required this.id,
      required this.name,
      required this.description,
      required this.apartmentId});
  String id;
  String name;
  String? description;
  String apartmentId;

  factory Building.fromJson(Map<String, dynamic> json) => Building(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      apartmentId: json['apartmentId']);
}
