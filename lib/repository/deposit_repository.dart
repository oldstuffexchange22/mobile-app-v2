import 'package:old_stuff_exchange/model/entity/deposit.dart';

abstract class DepositReq {
  Future<Deposit> create(String walletElectricName, String description,
      double amount);
}
