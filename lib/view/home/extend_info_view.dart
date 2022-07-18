import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/utils/utils.dart';
import 'package:old_stuff_exchange/view_model/provider/home_page_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/sign_in_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ExtendInfoView extends StatefulWidget {
  const ExtendInfoView({Key? key}) : super(key: key);

  @override
  State<ExtendInfoView> createState() => _ExtendInfoViewState();
}

class _ExtendInfoViewState extends State<ExtendInfoView> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    HomePageProvider homePageProvider = Provider.of<HomePageProvider>(context);
    SignInProvider signInProvider = Provider.of<SignInProvider>(context);
    User? currentUser = userProvider.currentUser;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Thêm',
            style: PrimaryFont.extraLight(22),
          ),
        ),
      ),
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                height: 10,
                color: Colors.transparent.withOpacity(0.08),
                thickness: 10,
                indent: 0,
                endIndent: 0,
              ),
              const SizedBox(
                height: 2,
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(
                      Utils.getString(currentUser?.imagesUrl).isEmpty
                          ? 'https://thuvienplus.com/themes/cynoebook/public/images/default-user-image.png'
                          : Utils.getString(currentUser?.imagesUrl),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      currentUser?.fullName ?? '',
                      style: PrimaryFont.regular(20),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(currentUser?.email ?? ''),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Divider(
                height: 2,
                color: Colors.transparent.withOpacity(0.08),
                thickness: 4,
                indent: 0,
                endIndent: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            FontAwesome5.wallet,
                            size: 28,
                            color: Colors.amberAccent,
                          ),
                        ),
                        title: const Text('Ví'),
                        onTap: () {
                          Navigator.of(context).pushNamed('/rechargeMoneyPage');
                        }),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Typicons.doc_text,
                          size: 28,
                          color: Colors.blue,
                        ),
                      ),
                      title: const Text('Đơn mua'),
                      onTap: () {
                        homePageProvider.selectedPageIndex = 2;
                      },
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          ModernPictograms.article_alt,
                          size: 28,
                          color: Colors.green,
                        ),
                      ),
                      title: const Text('Đơn bán'),
                      onTap: () {
                        homePageProvider.selectedPageIndex = 1;
                      },
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          FontAwesome5.history,
                          size: 28,
                          color: Colors.blue,
                        ),
                      ),
                      title: const Text('Lịch sử giao dịch'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/historyTransactionPage');
                      },
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          FontAwesome5.user_edit,
                          size: 26,
                          color: Colors.amber,
                        ),
                      ),
                      title: const Text('Cập nhật thông tin'),
                      onTap: () {
                        Navigator.of(context).pushNamed("/updateInfoPage");
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 20,
                color: Colors.transparent.withOpacity(0.08),
                thickness: 4,
                indent: 0,
                endIndent: 0,
              ),
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    FontAwesome5.sign_out_alt,
                    size: 28,
                    color: Colors.red,
                  ),
                ),
                title: const Text('Đăng xuất'),
                onTap: () async {
                  await _showConfirmSignOutDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmSignOutDialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          SignInProvider signInProvider = Provider.of<SignInProvider>(context);
          return AlertDialog(
            content: const SingleChildScrollView(
              child: Text('Bạn muốn đăng xuất ?'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await signInProvider.signOut(context);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                child: const Text('Xác nhận'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                child: const Text('Hủy'),
              )
            ],
          );
        });
  }
}
