class Building {
  Building({this.id, this.name, this.description, this.apartmentId});
  String? id;
  String? name;
  String? description;
  String? apartmentId;

  factory Building.fromJson(Map<String, dynamic> json) => Building(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      apartmentId: json['apartmentId']);
}
