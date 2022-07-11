import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/appStyle.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/category.dart';
import 'package:old_stuff_exchange/model/entity/product.dart';
import 'package:old_stuff_exchange/model/request/product_create.dart';
import 'package:old_stuff_exchange/view_model/provider/post_create_provider.dart';
import 'package:old_stuff_exchange/widgets/input/input.dart';
import 'package:provider/provider.dart';

class ProductDialog extends StatefulWidget {
  const ProductDialog({Key? key}) : super(key: key);

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _categoryId = '';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    PostProvider postProvider = Provider.of(context, listen: false);
    _categoryId = postProvider.categoryValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: true);
    List<Category> categoriesOption = postProvider.categories;
    return Container(
      width: screenSize.width * 0.6,
      height: screenSize.height * 0.7,
      decoration: AppStyle.decorationBgPrimary(),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text('Thông tin sản phẩm',
                              style: PrimaryFont.bold(16)
                                  .copyWith(color: Colors.white)))),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close))
              ]),
              const LabelBox(label: 'Tên sản phẩm :'),
              InputApp(
                  isRequired: true,
                  width: screenSize.width * 0.6,
                  icon: const Icon(Icons.description_outlined),
                  controller: _nameController),
              const LabelBox(label: 'Miêu tả :'),
              InputApp(
                  isRequired: true,
                  width: screenSize.width * 0.6,
                  icon: const Icon(Icons.description_outlined),
                  controller: _descriptionController),
              const LabelBox(label: 'Giá :'),
              InputNumberApp(
                  isRequired: true,
                  width: screenSize.width * 0.6,
                  icon: const Icon(Icons.description_outlined),
                  controller: _priceController),
              const LabelBox(label: 'Loại :'),
              Container(
                width: screenSize.width * 0.6,
                decoration: BoxDecoration(
                    color: kColorWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(24))),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: DropdownButton(
                      style: PrimaryFont.extraLight(16)
                          .copyWith(color: Colors.black),
                      icon: const Icon(Icons.arrow_downward_outlined),
                      menuMaxHeight: screenSize.height * 0.4,
                      iconSize: 24,
                      value: postProvider.categoryValue,
                      isExpanded: true,
                      underline: const SizedBox(),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      items: categoriesOption
                          .map((e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name.replaceAll('.', '')),
                              ))
                          .toList(),
                      onChanged: (selectedValue) {
                        setState(() {
                          _categoryId = selectedValue.toString();
                          postProvider.setCategoryValue =
                              selectedValue.toString();
                          postProvider.notify();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));
                    } else {
                      String name = _nameController.text;
                      String description = _descriptionController.text;
                      int price = int.parse(_priceController.text);
                      String categoryId = _categoryId;
                      String categoryName = postProvider.categories
                          .singleWhere((element) => element.id == categoryId)
                          .name;
                      CreateProduct newProduct = CreateProduct(
                          name: name,
                          description: description,
                          price: price,
                          categoryId: categoryId,
                          categoryName: categoryName);
                      postProvider.products.add(newProduct);
                      postProvider.notify();
                      showToastSuccess('Thêm mới sản phẩm thành công');
                      Navigator.pop(context);
                    }
                  },
                  style: AppStyle.btnCreateStyle(),
                  child: const Text('Thêm sản phẩm'),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LabelBox extends StatelessWidget {
  const LabelBox({Key? key, required this.label}) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 28, top: 12, bottom: 2),
      child: SizedBox(
        width: screenSize.width * 0.7,
        child: Text(
          label,
          style: PrimaryFont.regular(12).copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
