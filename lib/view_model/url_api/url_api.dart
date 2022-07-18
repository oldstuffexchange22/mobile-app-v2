class UrlApi {
  static const String serverPath =
      'https://old-stuff-exchange.azurewebsites.net/api/v1.0';
  static const String signinFirebase = '$serverPath/authorizes/firebase';
  static const String userController = '$serverPath/users';
  static const String postController = '$serverPath/posts';
  static const String apartmentController = '$serverPath/apartments';
  static const String buildingController = '$serverPath/buildings';
  static const String categoryController = '$serverPath/categories';
  static const String walletController = '$serverPath/wallets';
  static const String depositController = '$serverPath/deposits';
  static const String transactionController = '$serverPath/transactions';
}
