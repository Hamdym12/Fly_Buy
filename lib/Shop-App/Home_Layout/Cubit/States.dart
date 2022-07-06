import 'package:shop_app/Shop-App/models/changeFavorites_model.dart';
import 'package:shop_app/Shop-App/models/login_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingHomeState extends ShopStates{}

class ShopSuccessHomeState extends ShopStates{}

class ShopErrorHomeState extends ShopStates{
  final String? error;
  ShopErrorHomeState(this.error);
}

class ShopSuccessGategoriesState extends ShopStates{}

class ShopErrorGategoriesState extends ShopStates{}

class ShopSuccessChangeFavoritesState extends ShopStates{

  final ChangeFavoritesModel model;
  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates{}

class ShopSuccessGetFavoritesState extends ShopStates{}

class ShopErrorGetFavoritesState extends ShopStates{}

class ShopLoadingGetFavouritesState extends ShopStates{}

class ShopSuccessUserDataState extends ShopStates{
 final ShopLoginModel shopLoginModel;
  ShopSuccessUserDataState(this.shopLoginModel);
}

class ShopErrorUserDataState extends ShopStates{}

class ShopLoadingUserDataState extends ShopStates{}

class ShopSuccessUpdateUserState extends ShopStates{
  final ShopLoginModel shopLoginModel;
  ShopSuccessUpdateUserState(this.shopLoginModel);
}

class ShopErrorUpdateUserState extends ShopStates{}

class ShopLoadingUpdateUserState extends ShopStates{}
