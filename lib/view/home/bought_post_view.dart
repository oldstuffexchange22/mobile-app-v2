import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/view/home/bought_post_view/accomplished_bought_post.dart';
import 'package:old_stuff_exchange/view/home/bought_post_view/delivered_bought_post.dart';
import 'package:old_stuff_exchange/view/home/bought_post_view/delivery_bought_post.dart';
import 'package:old_stuff_exchange/view/home/bought_post_view/failure_bought_post.dart';
import 'package:old_stuff_exchange/view_model/provider/post_bought_provider.dart';
import 'package:provider/provider.dart';

class BoughtPostView extends StatefulWidget {
  const BoughtPostView({Key? key}) : super(key: key);

  @override
  State<BoughtPostView> createState() => _BoughtPostViewState();
}

class _BoughtPostViewState extends State<BoughtPostView>
    with TickerProviderStateMixin {
  final List<Tab> _tabs = const [
    Tab(
      text: 'Đang giao hàng',
    ),
    Tab(
      text: 'Đã giao hàng',
    ),
    Tab(
      text: 'Giao hàng thành công',
    ),
    Tab(
      text: 'Giao hàng thất bại',
    )
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    loadData();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(1);
  }

  Future<void> loadData() async {
    PostBoughtProvider postBoughtProvider =
        Provider.of<PostBoughtProvider>(context, listen: false);
    await postBoughtProvider.getAllPost();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Bài mua',
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
      body: TabBarView(controller: _tabController, children: const [
        DeliveryBoughtPost(),
        DeliveredBoughtPost(),
        AccomplishedBoughtPost(),
        FailureBoughtPost()
      ]),
    );
  }
}
