import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/view/home/sale_post_view/accomplished_post.dart';
import 'package:old_stuff_exchange/view/home/sale_post_view/active_post.dart';
import 'package:old_stuff_exchange/view/home/sale_post_view/delivered_post.dart';
import 'package:old_stuff_exchange/view/home/sale_post_view/delivery_post.dart';
import 'package:old_stuff_exchange/view/home/sale_post_view/failure_post.dart';
import 'package:old_stuff_exchange/view/home/sale_post_view/inactive_post.dart';
import 'package:old_stuff_exchange/view/home/sale_post_view/waiting_post.dart';
import 'package:old_stuff_exchange/view_model/provider/post_sale_provider.dart';
import 'package:provider/provider.dart';

class SalePostView extends StatefulWidget {
  const SalePostView({Key? key}) : super(key: key);

  @override
  State<SalePostView> createState() => _SalePostViewState();
}

class _SalePostViewState extends State<SalePostView>
    with TickerProviderStateMixin {
  final List<Tab> _tabs = [
    const Tab(
      text: 'Đã hủy',
    ),
    const Tab(text: 'Chờ xác nhận'),
    const Tab(text: 'Hoạt động'),
    const Tab(text: 'Đang giao hàng'),
    const Tab(text: 'Đã giao hàng'),
    const Tab(
      text: 'Giao thành công',
    ),
    const Tab(
      text: 'Giao thất bại',
    )
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    loadData();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.animateTo(3);
  }

  Future<void> loadData() async {
    PostSaleProvider postStatusProvider =
        Provider.of<PostSaleProvider>(context, listen: false);
    await postStatusProvider.getAllPostStatus();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Bài bán',
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
        InactivePost(),
        WaitingPost(),
        ActivePost(),
        DeliveryPost(),
        DeliveredPost(),
        AccomplishedPost(),
        FailurePost()
      ]),
    );
  }
}
