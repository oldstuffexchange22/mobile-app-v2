import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/view/home/appbar/extend_info_appbar.dart';
import 'package:old_stuff_exchange/view/home/appbar/home_appbar.dart';
import 'package:old_stuff_exchange/view/home/appbar/manage_post_appbar.dart';
import 'package:old_stuff_exchange/view/home/appbar/notify_appbar.dart';
import 'package:old_stuff_exchange/view/home/extend_info_view.dart';
import 'package:old_stuff_exchange/view/home/manage_post_view.dart';
import 'package:old_stuff_exchange/view/home/notify_view.dart';
import 'package:old_stuff_exchange/view/home/post_list_view.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedBottomNavigationIndex = 0;
  User? currentUser;
  int selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();

  final List<_BottomNavigationItem> _bottomNavigationItems = [
    _BottomNavigationItem(
      label: 'Trang chủ',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      widgetBuilder: (context) => const PostListView(),
    ),
    _BottomNavigationItem(
      label: 'Quản lí tin',
      icon: Icons.document_scanner_outlined,
      activeIcon: Icons.document_scanner,
      widgetBuilder: (context) => const ManagePostView(),
    ),
    _BottomNavigationItem(
      label: 'Thông báo',
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      widgetBuilder: (context) => const NotifyView(),
    ),
    _BottomNavigationItem(
      label: 'Thêm',
      icon: Icons.manage_history_outlined,
      activeIcon: Icons.manage_history,
      widgetBuilder: (context) => const ExtendInfoView(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    // userProvider.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    // userProvider.getCurrentUser();
    var screenSize = MediaQuery.of(context).size;
    List<Widget> appbar = [
      HomeAppBarContainer(
          screenSize: screenSize, searchController: searchController),
      const ManagePostAppBarContainer(),
      const NotifyAppBarContainer(),
      const ExtendAppBarContainer()
    ];
    return Scaffold(
      appBar: AppBar(
          title: Container(
        child: appbar[_selectedBottomNavigationIndex],
      )),
      body: IndexedStack(
        index: _selectedBottomNavigationIndex,
        children: _bottomNavigationItems
            .map(
              (item) => item.widgetBuilder(context),
            )
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedBottomNavigationIndex,
        iconSize: 32,
        unselectedLabelStyle:
            PrimaryFont.extraLight(12).copyWith(color: kColorText),
        items: _bottomNavigationItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                activeIcon: Icon(item.activeIcon),
                label: item.label,
              ),
            )
            .toList(),
        onTap: (newIndex) => setState(
          () => _selectedBottomNavigationIndex = newIndex,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _BtnCreatePost(screenSize: screenSize),
    );
  }
}

class _BtnCreatePost extends StatelessWidget {
  const _BtnCreatePost({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenSize.width * 0.2,
      height: screenSize.height * 0.2,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.blue,
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              const Icon(
                Icons.post_add_outlined,
                color: Colors.black,
              ),
              Text('Đăng bài',
                  style: PrimaryFont.semiBold(8).copyWith(
                    color: Colors.black,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationItem {
  const _BottomNavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.widgetBuilder,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final WidgetBuilder widgetBuilder;
}
