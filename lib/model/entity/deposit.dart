class Deposit {
  Deposit(
      {required this.id,
      required this.walletElectricName,
      required this.description,
      required this.amount,
      required this.createdAt,
      required this.userId});
  String id;
  String walletElectricName;
  String description;
  double amount;
  DateTime createdAt;
  String userId;

  factory Deposit.fromJson(Map<String, dynamic> json) => Deposit(
      id: json['id'] ?? '',
      walletElectricName: json['walletElectricName'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId']);

  Map<String, dynamic> toJson() => {
    'id' : id,
    'walletElectricName' : walletElectricName,
    'description' : description,
    'amount' : amount,
    'createdAt' : createdAt,
    'userId' : userId
  };
}
