// ignore_for_file: unnecessary_null_comparison, curly_braces_in_flow_control_structures
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Home_Layout/Home_Screen.dart';
import 'package:shop_app/Shop-App/Log-In/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Log-In/LogInScreen.dart';
import 'package:shop_app/Shop-App/Register/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/network/remote/BlocObserver.dart';
import 'package:shop_app/Shop-App/Shared/Constants/constants.dart';
import 'package:shop_app/Shop-App/network/local/Cash_Helper.dart';
import 'package:shop_app/Shop-App/network/remote/dio_helper.dart';
import 'package:shop_app/Shop-App/search/Cubit/Cubit.dart';
import 'Shop-App/On-boarding/onBoardingScreen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  BlocOverrides.runZoned(
        () async {
          await CacheHelper.init();
          Widget widget;
          bool? onBoarding = CacheHelper.getData(key:'onBoarding');
          token = CacheHelper.getData(key:'token');
          //print(token.toString());

          if(onBoarding != null ){
            if(token !=null ) widget = const HomeLayoutScreen();
            else widget = ShopLoginScreen();
          }else{
            widget = OnBoardingScreen();
          }

          runApp( MyApp(
            startWidget:widget,
          ));
      ShopLogInCubit();
      ShopCubit();
      ShopRegisterCubit();
      SearchCubit();
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

   MyApp({required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopCubit>(
      create: (BuildContext context)=>ShopCubit()..getHomeData()..getGategoriesData()..getFavoriteData()..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor:const Color.fromRGBO(7,39,67, 1),
            primarySwatch:Colors.blue,//Color.fromRGBO(7,39,67, 1),
            fontFamily: 'jannah',
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
                bodyText1:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25
                )
            ),
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                color: Colors.white,
                elevation: 0.0,
                systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.white
                )
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.blue,
                type: BottomNavigationBarType.fixed,
                elevation: 20.0,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
            )
        ),
        darkTheme: ThemeData(
            scaffoldBackgroundColor: Colors.black26
        ),
        themeMode: ThemeMode.light,

        home: startWidget,
      ),
    );
  }
}
