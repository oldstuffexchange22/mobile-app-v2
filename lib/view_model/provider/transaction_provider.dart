import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/config/constrant/transaction_type.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/transaction.dart';
import 'package:old_stuff_exchange/repository/implement/transaction_req_imp.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';

class TransactionProvider with ChangeNotifier {
  final SecureStorage secureStorage = SecureStorage();
  List<Transaction> _moneyInTransactions = [];
  List<Transaction> _moneyOutTransaction = [];
  List<Transaction> _moneyAllTransaction = [];

  List<Transaction> get moneyInTransaction => _moneyInTransactions;
  List<Transaction> get moneyOutTransaction => _moneyOutTransaction;
  List<Transaction> get moneyAllTransaction => _moneyAllTransaction;

  Future<void> loadData() async {
    try {
      _moneyAllTransaction.clear();
      _moneyAllTransaction =
          await TransactionReqImp().getTransactionsWithUser();
      notifyListeners();
    } catch (e) {
      showToastFail('Load data transactions error $e');
    }
  }

  Future<void> loadDataMoneyIn() async {
    try {
      _moneyInTransactions.clear();
      List<Transaction> transactionUser =
          await TransactionReqImp().getTransactionsWithUser();
      for (var transaction in transactionUser) {
        if (transaction.type == TransactionType.recharge ||
            transaction.type == TransactionType.sell ||
            transaction.type == TransactionType.refund) {
          _moneyInTransactions.add(transaction);
        }
      }
      notifyListeners();
    } catch (e) {
      showToastFail('Load data transactions error $e');
    }
  }

  Future<void> loadDataMoneyOut() async {
    try {
      _moneyOutTransaction.clear();
      List<Transaction> transactionUser =
          await TransactionReqImp().getTransactionsWithUser();
      for (var transaction in transactionUser) {
        if (transaction.type == TransactionType.bought) {
          _moneyOutTransaction.add(transaction);
        }
      }
      notifyListeners();
    } catch (e) {
      showToastFail('Load data transactions error $e');
    }
  }
}
