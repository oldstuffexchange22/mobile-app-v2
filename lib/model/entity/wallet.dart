class Wallet {
  Wallet(
      {required this.id,
      required this.balance,
      required this.currency,
      required this.type,
      required this.status,
      required this.description,
      required this.userId});
  String id;
  double balance;
  String type;
  String status;
  String currency;
  String description;
  String userId;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
      id: json['id'],
      balance: json['balance'],
      type: json['type'],
      currency: json['currency'],
      status: json['status'],
      description: json['description'],
      userId: json['userId']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'balance': balance,
        'type': type,
        'currency': currency,
        'status': status,
        'description': description,
        'userId': userId
      };
}
