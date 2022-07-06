import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/States.dart';
import 'package:shop_app/Shop-App/models/gategories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener:(context,state){} ,
      builder:(context,state){
        return ListView.separated(
            itemBuilder: (context,index)=>buildCatItem(ShopCubit.get(context).categoriesModel!.data!.data![index]),
            separatorBuilder: (context,index)=>const Divider(),
            itemCount: ShopCubit.get(context).categoriesModel!.data!.data!.length
        );
      }  ,

    );
  }

  Widget buildCatItem(DataModel model)=>Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        Image(
          image: NetworkImage(model.image!),
          height: 80,
          width: 80,
        ),
        const SizedBox(width: 10,),
        Text(
          model.name!,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700
          ),
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios)
      ],
    ),
  );
}
