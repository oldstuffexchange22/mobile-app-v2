import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/appStyle.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/view/post/create_post.dart';
import 'package:old_stuff_exchange/widgets/input/input.dart';

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
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text(
              'Nạp tiền',
              style: PrimaryFont.semiBold(18).copyWith(color: Colors.white),
            )),
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
              const SizedBox(
                height: 140,
              ),
              const LabelBox(label: 'Nhập số tiền (ví dụ 20 = 20.000đ) :'),
              const SizedBox(
                width: 60,
              ),
              SizedBox(
                width: screenSize.width * 0.8,
                child: InputNumberApp(
                    icon: const Icon(FontAwesome5.dollar_sign),
                    controller: _moneyController),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {},
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
