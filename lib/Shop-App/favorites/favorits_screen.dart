import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/States.dart';
import 'package:shop_app/Shop-App/Shared/Components/buildListProduct.dart';
import 'package:shop_app/Shop-App/Shared/Constants/Colors.dart';
import 'package:shop_app/Shop-App/models/FavoritesModel.dart';
import 'package:shop_app/Shop-App/models/FavoritesModel.dart';

import '../models/FavoritesModel.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener:(context,state){} ,
      builder:(context,state){
        return ConditionalBuilder(
            condition: state is! ShopLoadingGetFavouritesState,
            builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildListProduct(ShopCubit.get(context).favoritesModel!.data!.data![index].product!, context),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: ShopCubit.get(context).favoritesModel!.data!.data!.length),
            fallback: (context) => const Center(child: CircularProgressIndicator()
        )
        );
       });
  }
  }



