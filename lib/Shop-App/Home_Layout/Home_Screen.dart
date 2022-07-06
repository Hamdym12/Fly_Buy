import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/States.dart';
import 'package:shop_app/Shop-App/Log-In/LogInScreen.dart';
import 'package:shop_app/Shop-App/Shared/Components/MyNavigator.dart';
import 'package:shop_app/Shop-App/network/local/Cash_Helper.dart';
import 'package:shop_app/Shop-App/search/search_screen.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=ShopCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Image.asset('assets/images/carts.png',height:40,width: 30,),
              actions: [
                IconButton(
                    onPressed: (){
                      NavigateTo(context,  SearchScreen());
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
            body: cubit.bottomScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: const Color.fromRGBO(7,39,67, 1),
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeBottom(index);
              },
              items: const[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps),
                    label: "Categories"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: "Favorites"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: "Settings"
                ),
              ],
            ),
          );
        });
  }
}
