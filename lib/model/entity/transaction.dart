class Transaction {
  Transaction(
      {required this.id,
      required this.description,
      required this.status,
      required this.type,
      required this.coinExchange,
      required this.balance,
      required this.createdAt,
      required this.walletId,
      required this.postId,
      required this.depositId});
  String id;
  String description;
  String status;
  String type;
  double coinExchange;
  double balance;
  DateTime createdAt;
  String walletId;
  String postId;
  String depositId;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      type: json['type'],
      coinExchange: json['coinExchange'] ?? 0,
      balance: json['balance'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      walletId: json['walletId'] ?? '',
      postId: json['postId'] ?? '',
      depositId: json['depositId'] ?? '');

  Map<String, dynamic> toJson() => {
     'id' : id,
     'description' : description,
     'status' : status,
     'type' : type,
     'coinExchange' : coinExchange,
     'balance' : balance,
     'createdAt' : createdAt,
     'walletId' : walletId,
     'postId' : postId,
     'depositId' : depositId
  };
}
