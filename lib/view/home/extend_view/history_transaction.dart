import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/view/home/extend_view/history_transaction_tab/money_all.dart';
import 'package:old_stuff_exchange/view/home/extend_view/history_transaction_tab/money_in.dart';
import 'package:old_stuff_exchange/view/home/extend_view/history_transaction_tab/money_out.dart';
import 'package:old_stuff_exchange/view_model/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class HistoryTransactionPage extends StatefulWidget {
  const HistoryTransactionPage({Key? key}) : super(key: key);

  @override
  State<HistoryTransactionPage> createState() => _HistoryTransactionPageState();
}

class _HistoryTransactionPageState extends State<HistoryTransactionPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> _tabs = const [
    Tab(
      text: 'Tất cả',
    ),
    Tab(
      text: 'Tiền vào',
    ),
    Tab(
      text: 'Tiền ra',
    )
  ];
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Lịch sử giao dịch',
          style: PrimaryFont.extraLight(22),
        ),
        bottom: PreferredSize(
          preferredSize: _tabs[0].preferredSize,
          child: ColoredBox(
            color: kColorWhite,
            child: TabBar(
              tabs: _tabs,
              controller: _tabController,
              indicatorColor: kColorBlue,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4, color: kColorBlue),
                  insets: const EdgeInsets.symmetric(horizontal: 4)),
              labelColor: Colors.black,
              labelStyle: PrimaryFont.semiBold(16),
            ),
          ),
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: const [MoneyAllPage(), MoneyInPage(), MoneyOutPage()]),
    );
  }
}
