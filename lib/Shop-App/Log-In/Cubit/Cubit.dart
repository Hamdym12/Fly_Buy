import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Log-In/Cubit/States.dart';
import 'package:shop_app/Shop-App/models/login_model.dart';
import 'package:shop_app/Shop-App/network/end_Points.dart';
import 'package:shop_app/Shop-App/network/remote/dio_helper.dart';

class ShopLogInCubit extends Cubit<ShopLogInStates>{
  ShopLogInCubit() : super(ShopLogInInitialState());
  static ShopLogInCubit get(context)=>BlocProvider.of(context); // an object from the cubit

  late ShopLoginModel loginModel;

  Future<void> postLogin({required String email, required String password,}) async {
    emit(ShopLogInLoadingState());
    var head = <String, String>{
      "Content-Type": 'application/json',
      'lang': 'en',
    };
    Dio _dio = Dio();
    const url = "https://student.valuxapps.com/api/login";
    try {
      final response = await _dio.post(url,
          data:{
            'email': email,
            'password': password,
          },
          options: Options(
            followRedirects: false,
            receiveDataWhenStatusError: true,
            headers: head,
          ));
      print(response.data);
      loginModel = ShopLoginModel.fromJson(response.data);
      emit(ShopLogInSuccessState(loginModel));
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
        emit(ShopLogInErrorState(e.error.toString()));
      } else {
        print(e.message);
      }
    }
  }

  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  void changePasswordVisibility(){
    isPassword=!isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibility());
  }

}

/*
  void userLogIn ({required String email, required String password,})async {
    emit(ShopLogInLoadingState());
    try {
     await DioHelper.postData(
          url: LOGIN,
          data: {
            'email': email,
            'password': password,
          }).then((value) {
        print(value!.data);
          loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopLogInSuccessState(loginModel));
      }).catchError((error) {
        emit(ShopLogInErrorState(error.toString()));
      });
    } catch (error) {
      print(error);
    }
  }
*/