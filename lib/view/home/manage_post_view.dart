import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class ManagePostView extends StatefulWidget {
  const ManagePostView({Key? key}) : super(key: key);

  @override
  State<ManagePostView> createState() => _ManagePostViewState();
}

class _ManagePostViewState extends State<ManagePostView>
    with TickerProviderStateMixin {
  final List<Tab> _tabs = [
    const Tab(child: Text('Đã tắt')),
    const Tab(text: 'Đang chờ'),
    const Tab(text: 'Hoạt động'),
    const Tab(text: 'Đang giao hàng'),
    const Tab(text: 'Đã giao hàng'),
  ];
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.animateTo(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Quản lí tin',
            style: PrimaryFont.extraLight(22),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: _tabs[0].preferredSize,
          child: ColoredBox(
            color: kColorWhite,
            child: TabBar(
              tabs: _tabs,
              controller: _tabController,
              isScrollable: true,
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
      body: TabBarView(controller: _tabController, children: [
        Text('1'),
        Text('2'),
        Text('3'),
        Text('3'),
        Text('3'),
      ]),
    );
  }
}
