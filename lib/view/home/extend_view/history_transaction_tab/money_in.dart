import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:old_stuff_exchange/config/constrant/transaction_type.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/transaction.dart';
import 'package:old_stuff_exchange/view_model/provider/transaction_provider.dart';
import 'package:old_stuff_exchange/widgets/center_refresh/center_refresh.dart';
import 'package:provider/provider.dart';

class MoneyInPage extends StatefulWidget {
  const MoneyInPage({Key? key}) : super(key: key);

  @override
  State<MoneyInPage> createState() => _MoneyInPageState();
}

class _MoneyInPageState extends State<MoneyInPage> {
  late Widget emptyWidget;
  late Timer _timer;
  @override
  void initState() {
    TransactionProvider transactionProvider =
        Provider.of(context, listen: false);
    transactionProvider.loadDataMoneyIn();
    emptyWidget = const CenterRefresh();
    _timer = Timer(const Duration(milliseconds: 7000), () {
      if (transactionProvider.moneyInTransaction.isEmpty) {
        setState(() {
          emptyWidget = const CenterNotifyEmpty();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);
    List<Transaction> transactions = transactionProvider.moneyInTransaction;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => transactionProvider.loadDataMoneyIn(),
        child: transactions.isEmpty
            ? Center(child: emptyWidget)
            : ListView.builder(
                itemBuilder: ((context, i) {
                  Transaction transaction = transactions[i];
                  Color titleColor = i % 2 == 0
                      ? Colors.white
                      : Colors.black.withOpacity(0.06);
                  IconData iconData = FontAwesome5.shopify;
                  if (transaction.type == TransactionType.recharge) {
                    iconData = FontAwesome.login;
                  } else if (transaction.type == TransactionType.sell) {
                    iconData = FontAwesome5.shopify;
                  } else {
                    iconData = FontAwesome5.undo;
                  }
                  return ListTile(  
                    tileColor: titleColor,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          width: screenSize.width * 0.14,
                          height: screenSize.height * 16,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.2),
                                  width: 3)),
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              child: Icon(
                                iconData,
                                color: Colors.green,
                                size: 20,
                              ))),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          transaction.description,
                          style: PrimaryFont.semiBold(18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.createdAt
                                      .add(const Duration(hours: 7))
                                      .toString()
                                      .substring(0, 18),
                                  style: PrimaryFont.regular(14).copyWith(
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                                Text(
                                  'Số dư ví: ${transaction.balance}00đ',
                                  style: PrimaryFont.regular(15),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                '+${transaction.coinExchange}00đ',
                                style: PrimaryFont.semiBold(21),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  );
                }),
                itemCount: transactions.length,
              ),
      ),
    );
  }
}
