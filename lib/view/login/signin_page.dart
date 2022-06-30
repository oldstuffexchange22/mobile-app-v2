import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:old_stuff_exchange/config/constrant/asset_path.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/utils/hex_color.dart';

import 'package:old_stuff_exchange/view_model/provider/sign_in_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:old_stuff_exchange/widgets/button/button_social.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    var styleBtnLogin = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        )),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(fontSize: 14, fontFamily: 'Blinker')),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xFF6A74CF)));
    SignInProvider signInProvider =
        Provider.of<SignInProvider>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 7,
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: SvgPicture.asset(AssetPath.homeLogo),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'OLD STUFF EXCHANGE',
                              style: PrimaryFont.semiBold(20)
                                  .copyWith(color: kColorWhite),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            InputLogin(
                              screenSize: screenSize,
                              userIcon:
                                  const Icon(Icons.account_circle_outlined),
                              label: 'User name',
                              controller: userNameController,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            InputLogin(
                              screenSize: screenSize,
                              userIcon: const Icon(
                                Icons.lock_clock_outlined,
                              ),
                              label: 'Password',
                              controller: passwordController,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                                width: screenSize.width * 0.7,
                                height: screenSize.height * 0.05,
                                child: ElevatedButton(
                                    style: styleBtnLogin,
                                    onPressed: () {
                                      final userName = userNameController.text;
                                      final password = passwordController.text;
                                      showToastFail('Chức năng chưa hỗ trợ');
                                    },
                                    child: const Text('Login')))
                          ],
                        ),
                      )
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'or connect with',
                              style: PrimaryFont.extraLight(16)
                                  .copyWith(color: HexColor('7A7A7A')),
                            ),
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: screenSize.width * 0.8,
                          height: screenSize.height * 0.04,
                          child: ButtonSocial(
                              content: "Continue with google",
                              voidCallBack: () async {
                                await signInProvider.signInWithGoogle(context);
                              },
                              assetName: AssetPath.google),
                        ),
                      ),
                      Expanded(flex: 5, child: Container())
                    ],
                  ))
            ],
          ),
        ));
  }
}

class InputLogin extends StatelessWidget {
  const InputLogin(
      {Key? key,
      required this.screenSize,
      required this.userIcon,
      required this.label,
      required this.controller})
      : super(key: key);

  final Size screenSize;
  final Icon userIcon;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenSize.width * 0.7,
      height: screenSize.height * 0.07,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 50),
            fillColor: kColorWhite,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: kColorWhite,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            prefixIcon: userIcon,
            labelText: label,
            labelStyle: MaterialStateTextStyle.resolveWith((states) {
              return PrimaryFont.regular(16).copyWith(color: kColorText);
            })),
      ),
    );
  }
}
