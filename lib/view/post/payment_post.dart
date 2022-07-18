import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/constrant/wallet_type.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/model/entity/product.dart';
import 'package:old_stuff_exchange/model/entity/wallet.dart';
import 'package:old_stuff_exchange/view_model/provider/post_payment_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:provider/provider.dart';

class PaymentPost extends StatefulWidget {
  const PaymentPost({Key? key}) : super(key: key);

  @override
  State<PaymentPost> createState() => _PaymentPostState();
}

class _PaymentPostState extends State<PaymentPost> {
  String _walletSelected = WalletType.basic;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    PostPaymentProvider postPaymentProvider =
        Provider.of<PostPaymentProvider>(context);
    Post currentPost = postPaymentProvider.currentPost;
    List<Product> products = currentPost.products;
    Wallet? defaultWallet = userProvider.defaultWallet;
    Wallet? promotionWallet = userProvider.promotionWallet;
    if (((promotionWallet?.balance ?? 0) - currentPost.price) <= 0 &&
        ((defaultWallet?.balance ?? 0) - currentPost.price) <= 0) {
      _walletSelected = '';
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Thanh toán đơn hàng'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Lựa chọn ví :',
                    style: PrimaryFont.regular(18),
                  )),
              const SizedBox(
                height: 8,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: kColorPrimary.withOpacity(0.12),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                            'Ví chính (Số dư : ${defaultWallet?.balance}00)'),
                        leading: Radio(
                            value: WalletType.basic,
                            groupValue: _walletSelected,
                            onChanged: (String? selected) {
                              setState(() {
                                if (((defaultWallet?.balance ?? 0) -
                                        currentPost.price) >
                                    0) {
                                  _walletSelected = selected ?? '';
                                } else {
                                  showToastFail('Số dư không đủ để thanh toán');
                                }
                              });
                            }),
                      ),
                      ListTile(
                        title: Text(
                            'Ví khuyến mãi (Số dư : ${promotionWallet?.balance}00)'),
                        leading: Radio(
                            value: WalletType.promotion,
                            groupValue: _walletSelected,
                            onChanged: (String? selected) {
                              setState(() {
                                if (((promotionWallet?.balance ?? 0) -
                                        currentPost.price) >
                                    0) {
                                  _walletSelected = selected ?? '';
                                } else {
                                  showToastFail('Số dư không đủ để thanh toán');
                                }
                              });
                            }),
                      ),
                      Visibility(
                        visible: false,
                        child: Radio(
                            value: '',
                            groupValue: _walletSelected,
                            onChanged: (String? selected) {}),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Nơi giao hàng : ${currentPost.author?.building?.name}',
                    style: PrimaryFont.regular(18),
                  )),
              const SizedBox(
                height: 12,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('Danh sách sản phẩm : ',
                      style: PrimaryFont.regular(18))),
              const SizedBox(
                height: 8,
              ),
              _listProduct(products),
              const SizedBox(
                height: 12,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('Số tiền cần thanh toán : ',
                      style: PrimaryFont.regular(18))),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  '${currentPost.price}00 đ',
                  style: PrimaryFont.bold(24).copyWith(color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Visibility(
                visible: _walletSelected != '',
                child: _walletSelected == WalletType.basic
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Số dư còn lại (ví chính) : ${(defaultWallet?.balance ?? 0) - currentPost.price}00 đ',
                          style: PrimaryFont.regular(20),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Số dư còn lại (ví khuyến mãi): ${(promotionWallet?.balance ?? 0) - currentPost.price}00 đ',
                          style: PrimaryFont.regular(20),
                        ),
                      ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
            width: screenSize.width * 0.5,
            child: FloatingActionButton(
              backgroundColor: _walletSelected == ''
                  ? Colors.purple.withOpacity(0.5)
                  : Colors.purple,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2))),
              onPressed: () async {
                if (_walletSelected != '') {
                  await postPaymentProvider.paymentPost(
                      context, currentPost.id, _walletSelected);
                } else {
                  // showToastFail('Chưa chọn ví để thanh toán');
                }
              },
              child: const Text('Thanh toán'),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }

  Widget _listProduct(List<Product> products) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: kColorPrimary.withOpacity(0.12),
        height: 36 * products.length.toDouble(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ListView.builder(
              itemBuilder: (context, index) {
                Product product = products[index];
                return SizedBox(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(flex: 2, child: _productField(product.name)),
                        Flexible(
                            flex: 2,
                            child: _productField('${product.price}00')),
                        Flexible(
                            flex: 5, child: _productField(product.description)),
                      ]),
                );
              },
              itemCount: products.length),
        ),
      ),
    );
  }

  Padding _productField(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        showDuration: const Duration(seconds: 1),
        message: content,
        child: Text(
          content,
          overflow: TextOverflow.ellipsis,
          style: PrimaryFont.regular(16),
        ),
      ),
    );
  }
}
