// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/States.dart';
import 'package:shop_app/Shop-App/Shared/Constants/constants.dart';
import 'package:shop_app/Shop-App/categories/categories_screen.dart';
import 'package:shop_app/Shop-App/favorites/favorits_screen.dart';
import 'package:shop_app/Shop-App/models/FavoritesModel.dart';
import 'package:shop_app/Shop-App/models/changeFavorites_model.dart';
import 'package:shop_app/Shop-App/models/gategories_model.dart';
import 'package:shop_app/Shop-App/models/home_model.dart';
import 'package:shop_app/Shop-App/models/login_model.dart';
import 'package:shop_app/Shop-App/network/remote/dio_helper.dart';
import 'package:shop_app/Shop-App/products/products_screen.dart';
import 'package:shop_app/Shop-App/settings/settings_screen.dart';

import '../../network/end_Points.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
     SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }


  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  Future<void> getHomeData({
    Map<String, dynamic>?query
  }) async {
    emit(ShopLoadingHomeState());
    var head = <String, String>{
      "Content-Type": 'application/json',
      'lang': 'en',
      'Authorization': token!,
    };
    Dio _dio = Dio();
    const url = "https://student.valuxapps.com/api/home";
    try {
      final response = await _dio.get(url,
          queryParameters: query,
          options: Options(
            followRedirects: false,
            receiveDataWhenStatusError: true,
            headers: head,
          ));
      print(response.data);
      homeModel = HomeModel.fromJson(response.data);

      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id!: element.inFavorites!
        });
      }

      //print(favorites.toString());

      //printFullText(homeModel!.data.toString());
      emit(ShopSuccessHomeState());
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
        emit(ShopErrorHomeState(e.error.toString()));
      } else {
        print(e.message);
      }
    }
  }

  CategoriesModel? categoriesModel;
  void getGategoriesData({
    Map<String, dynamic>?query,
  }) async {
    var head = <String, String>{
      "Content-Type": 'application/json',
      'lang': 'en',
    };
    Dio _dio = Dio();
    const url = "https://student.valuxapps.com/api/categories";
    try {
      final response = await _dio.get(url,
          queryParameters: query,
          options: Options(
            followRedirects: false,
            receiveDataWhenStatusError: true,
            headers: head,
          ));
      //print(response.data);
      categoriesModel = CategoriesModel.fromJson(response.data);
      emit(ShopSuccessGategoriesState());
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
        emit(ShopErrorGategoriesState());
      } else {
        print(e.message);
      }
    }
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      //print(value.data);

      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      }else{
        getFavoriteData();
      }

      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoriteModel? favoritesModel;
  void getFavoriteData(){
    DioHelper.getData(
        url: FAVORITES,
        token: token,
        ).then((value) {
      emit(ShopLoadingGetFavouritesState());
      favoritesModel=FavoriteModel.fromJson(value.data);
      //  printFullText(value.data.toString());
      emit(ShopSuccessGetFavoritesState());
    }).
    catchError((error)
    {
      emit(ShopErrorGetFavoritesState());
      print(error.toString());
    });
  }

  ShopLoginModel? userModel;
  void getUserData(){
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      emit(ShopLoadingUserDataState());
      userModel=ShopLoginModel.fromJson(value.data);
       //printFullText(userModel!.data!.name.toString());
      emit(ShopSuccessUserDataState(userModel!));
    }).
    catchError((error)
    {
      emit(ShopErrorUserDataState());
      print(error.toString());
    });
  }


  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }){
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value) {
      emit(ShopLoadingUserDataState());
      userModel=ShopLoginModel.fromJson(value.data);
      print(value.data);
      //printFullText(userModel!.data!.name.toString());
      emit(ShopSuccessUserDataState(userModel!));
    }).
    catchError((error)
    {
      emit(ShopErrorUserDataState());
      print(error.toString());
    });
  }
}
