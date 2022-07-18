import 'package:old_stuff_exchange/model/entity/transaction.dart';

abstract class TransactionReq {
  Future<List<Transaction>> getTransactionsWithWallet(String walletId);
  Future<List<Transaction>> getTransactionsWithUser();
}
