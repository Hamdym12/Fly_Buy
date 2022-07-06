import 'package:shop_app/Shop-App/models/login_model.dart';

abstract class ShopLogInStates{}

class ShopLogInInitialState extends ShopLogInStates{}

class ShopLogInLoadingState extends ShopLogInStates{}

class ShopLogInSuccessState extends ShopLogInStates{
  final ShopLoginModel loginModel;
  ShopLogInSuccessState(this.loginModel);
}

class ShopLogInErrorState extends ShopLogInStates{
  final String? error;
  ShopLogInErrorState(this.error);
}
class ShopChangePasswordVisibility extends ShopLogInStates{}