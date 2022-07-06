import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Log-In/Cubit/States.dart';
import 'package:shop_app/Shop-App/Register/Cubit/States.dart';
import 'package:shop_app/Shop-App/models/login_model.dart';
import 'package:shop_app/Shop-App/network/end_Points.dart';
import 'package:shop_app/Shop-App/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>{
  ShopRegisterCubit() : super(ShopRegisterInitialState());
  static ShopRegisterCubit get(context)=>BlocProvider.of(context); // an object from the cubit

  late ShopLoginModel loginModel;

  Future<void> userRegister({required String email,
    required String password,
    required String name,
    required String phone,}) async {
    emit(ShopRegisterLoadingState());
    var head = <String, String>{
      "Content-Type": 'application/json',
      'lang': 'en',
    };
    Dio _dio = Dio();
    const url = "https://student.valuxapps.com/api/register";
    try {
      final response = await _dio.post(url,
          data:{
            'name': email,
            'email': email,
            'password': password,
            'phone': email,

          },
          options: Options(
            followRedirects: false,
            receiveDataWhenStatusError: true,
            headers: head,
          ));
      print(response.data);
      loginModel = ShopLoginModel.fromJson(response.data);
      emit(ShopRegisterSuccessState(loginModel));
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
        emit(ShopRegisterErrorState(e.error.toString()));
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
    emit(ShopRegisterChangePasswordVisibility());
  }

}

/*
  void userRegister ({required String email, required String password,})async {
    emit(ShopRegisterLoadingState());
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