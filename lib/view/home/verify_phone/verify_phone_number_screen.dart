// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/view/home/extend_view/update_info.dart';
import 'package:old_stuff_exchange/view_model/provider/home_page_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:old_stuff_exchange/widgets/pin_input.dart';
import 'package:provider/provider.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';
  final String phoneNumber;

  const VerifyPhoneNumberScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify phone number'),
        centerTitle: true,
      ),
      body: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber,
        signOutOnSuccessfulVerification: true,
        linkWithExistingUser: false,
        autoRetrievalTimeOutDuration: const Duration(seconds: 60),
        otpExpirationDuration: const Duration(seconds: 60),
        builder: (context, controller) {
          UserProvider userProvider = Provider.of<UserProvider>(context);
          HomePageProvider homePageProvider =
              Provider.of<HomePageProvider>(context);
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.12),
            appBar: AppBar(
              backgroundColor: Colors.white,
              actions: [
                if (controller.codeSent)
                  TextButton(
                    onPressed: controller.isOtpExpired
                        ? () async {
                            await controller.sendOTP();
                          }
                        : null,
                    child: Text(
                      controller.isOtpExpired
                          ? 'Resend'
                          : '${controller.otpExpirationTimeLeft.inSeconds}s',
                      style: const TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                const SizedBox(width: 5),
              ],
            ),
            body: controller.isSendingCode
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          'Sending OTP',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    controller: scrollController,
                    children: [
                      Text(
                        "We've sent an SMS with a verification code to ${widget.phoneNumber}",
                        style: PrimaryFont.regular(18),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      if (controller.isListeningForOtpAutoRetrieve)
                        Column(
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 50),
                            Text(
                              'Listening for OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 15),
                            Divider(),
                            Text('OR', textAlign: TextAlign.center),
                            Divider(),
                          ],
                        ),
                      const SizedBox(height: 15),
                      const Text(
                        'Enter OTP',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      PinInputField(
                        length: 6,
                        onFocusChange: (hasFocus) async {
                          if (hasFocus) await _scrollToBottomOnKeyboardOpen();
                        },
                        onSubmit: (enteredOtp) async {
                          await Timer(const Duration(milliseconds: 5000),
                              () async {
                            bool verified =
                                await controller.verifyOtp(enteredOtp);
                            if (verified) {
                              await userProvider.updateUser(context, 'PHONE',
                                  widget.phoneNumber.substring(3));
                              homePageProvider.selectedPageIndex = 3;

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/homePage', ((route) => false));
                              Navigator.of(context)
                                  .pushNamed('/updateInfoPage');
                              // setState(() {
                              //   _originUser?.phone = _phoneController.text;
                              //   _isShowBtnPhoneSave = false;
                              //   _isShowPhoneState = false;
                              // });
                            } else {
                              showToastFail('Sai rồi bạn ơi');
                            }
                          });
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
