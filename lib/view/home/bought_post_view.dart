import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:flutter/cupertino.dart';

class BoughtPostView extends StatefulWidget {
  const BoughtPostView({Key? key}) : super(key: key);

  @override
  State<BoughtPostView> createState() => _BoughtPostViewState();
}

class _BoughtPostViewState extends State<BoughtPostView> with TickerProviderStateMixin{
  final List<Tab> _tabs = const [
    Tab(text: 'Đang giao hàng',),
    Tab(text: 'Đã giao hàng',),
    Tab(text: 'Giao hàng thành công',),
    Tab(text: 'Giao hàng thất bại',)
  ];
  late TabController _tabController ;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(2);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text('Bài mua', style: PrimaryFont.extraLight(22)),
        ),
      ),
    );
  }
}
