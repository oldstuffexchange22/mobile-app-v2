import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/appStyle.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/wallet.dart';
import 'package:old_stuff_exchange/view/post/create_post.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:old_stuff_exchange/widgets/input/input.dart';
import 'package:provider/provider.dart';

class RechargeMoneyPage extends StatefulWidget {
  const RechargeMoneyPage({Key? key}) : super(key: key);

  @override
  State<RechargeMoneyPage> createState() => _RechargeMoneyPageState();
}

class _RechargeMoneyPageState extends State<RechargeMoneyPage> {
  @override
  void dispose() {
    _moneyController.dispose();
    super.dispose();
  }

  final TextEditingController _moneyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    Wallet? defaultWallet = userProvider.defaultWallet;
    Wallet? promotionWallet = userProvider.promotionWallet;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ví',
          style: PrimaryFont.semiBold(18).copyWith(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kColorBackGroundStart, kColorBackGroundEnd])),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kColorBackGroundStart, kColorBackGroundEnd])),
        child: SizedBox(
          height: screenSize.height,
          child: Column(
            children: [
              Divider(
                height: 10,
                color: Colors.transparent.withOpacity(0.06),
                thickness: 10,
                indent: 0,
                endIndent: 0,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: screenSize.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: 'Số dư ví chính : ',
                            style: PrimaryFont.semiBold(18),
                            children: [
                          TextSpan(
                              text: '${defaultWallet?.balance}00đ',
                              style: PrimaryFont.semiBold(20).copyWith(
                                color: Colors.green,
                              ))
                        ])),
                    const SizedBox(
                      height: 12,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Số dư ví khuyến mãi : ',
                            style: PrimaryFont.semiBold(18),
                            children: [
                          TextSpan(
                              text: '${promotionWallet?.balance}00đ',
                              style: PrimaryFont.semiBold(20)
                                  .copyWith(color: Colors.green))
                        ]))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                height: 10,
                color: Colors.transparent.withOpacity(0.08),
                thickness: 6,
                indent: 0,
                endIndent: 0,
              ),
              const LabelBox(label: 'Nhập số tiền :'),
              const SizedBox(
                width: 60,
              ),
              SizedBox(
                width: screenSize.width * 0.8,
                child: InputMoneyApp(
                    isRequired: true,
                    icon: const Icon(FontAwesome5.dollar_sign),
                    controller: _moneyController),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    double amount = double.parse(_moneyController.text);
                    await userProvider.rechargeMoney(context, amount);
                    _moneyController.clear();
                  },
                  style: AppStyle.btnUploadStyle(),
                  child: SizedBox(
                    width: screenSize.width * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        Text('Nạp tiền')
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: screenSize.width * 0.8,
                child: RichText(
                  text: TextSpan(
                      text: 'Chú ý : ',
                      style: PrimaryFont.semiBold(14).copyWith(
                          color: Colors.red,
                          decoration: TextDecoration.underline),
                      children: [
                        TextSpan(
                            text:
                                'tiền bạn nạp vào sẽ được trích đi 10% để dành cho các hoạt động từ thiện.',
                            style: PrimaryFont.semiBold(14).copyWith(
                                decoration: TextDecoration.none,
                                fontStyle: FontStyle.italic))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
