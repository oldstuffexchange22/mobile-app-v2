import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:old_stuff_exchange/config/constrant/asset_path.dart';
import 'package:old_stuff_exchange/config/themes/theme.dart';
import 'package:old_stuff_exchange/view_model/provider/sign_in_provider.dart';
import 'package:old_stuff_exchange/widgets/button/button_social.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignInProvider signInProvider =
        Provider.of<SignInProvider>(context, listen: false);
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: Stack(
          children: [
            SizedBox.expand(
              child: SvgPicture.asset(AssetPath.homeLogo),
            ),
            Center(
              child: Text(
                'OLD STUFF EXCHANGE',
                style: PrimaryFont.medium(26),
              ),
            )
          ],
        )),
        Expanded(
            child: Center(
          child: ButtonSocial(
              content: "Login With Google",
              voidCallBack: () => signInProvider.signInWithGoogle(context),
              assetName: AssetPath.google),
        ))
      ],
    ));
  }
}
