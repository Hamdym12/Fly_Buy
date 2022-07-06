import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/States.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop_app/Shop-App/Shared/Components/showToast.dart';
import 'package:shop_app/Shop-App/Shared/Constants/Colors.dart';
import 'package:shop_app/Shop-App/models/gategories_model.dart';
import 'package:shop_app/Shop-App/models/home_model.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessChangeFavoritesState){
          if(!state.model.status!){
            showToast(
                text: state.model.message!,
                state: ToastStates.ERROR
            );
          }
        }
      },
        builder:(context,state){
        return ConditionalBuilder(
            condition: ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoriesModel != null,
            builder: (context)=> productsBuilder(ShopCubit.get(context).homeModel!,
                ShopCubit.get(context).categoriesModel!,context),
            fallback: (context)=>const Center(child: CircularProgressIndicator(),)
        );
        } ,
       );
  }

  Widget productsBuilder(HomeModel model,CategoriesModel categoriesModel,context)=> SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
            items: model.data!.banners.map((value) => Image(
                image: NetworkImage('${value.image}'),
              width: double.infinity,
              fit: BoxFit.contain,
            )).toList(),
            options: CarouselOptions(
              reverse: false,
              initialPage: 0,
              autoPlay: true,
              height:250,
              enableInfiniteScroll: true,
              viewportFraction: 1.0,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal
            )
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style:  TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height:10),
              Container(
                height: 100,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index)=>buildGategoryItem(categoriesModel.data!.data![index]),
                    separatorBuilder: (context,index)=>const SizedBox(width: 10,),
                    itemCount: categoriesModel.data!.data!.length,
                ),
              ),
              const SizedBox(height:15),
              const Text(
                'New Products',
                style:  TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          color: Colors.grey[300],
          child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          childAspectRatio: 1/1.73,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              model.data!.products.length,
                  (index) => buildGridProduct(model.data!.products[index],context)
          )
          ),
        ),
      ],
    ),
  );

  Widget buildGategoryItem(DataModel model)=> Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
       Image(image: NetworkImage(model.image!),
        height: 100,
        width: 100,
        fit: BoxFit.cover,


      ),
      Container(
        color: Colors.black.withOpacity(0.8),
        width: 100,
        child:  Text(
          model.name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white
          ),
        ),
      )
    ],
  );

  Widget buildGridProduct(ProductModel model,context)=> Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image!),
              width: double.infinity,
              height: 200,
            ),
            if(model.discount !=0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              color: Colors.red,
              child: const Text(
                'DISCOUNT',
                style: TextStyle(
                  fontSize: 9.0,
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  height: 1.3
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(
                     '${model.price.round()}',
                     maxLines: 2,
                     overflow: TextOverflow.ellipsis,
                     style: const TextStyle(
                         fontSize: 14.0,
                         color:Colors.blue
                     ),
                   ),
                   const SizedBox(width: 7.0),
                   if(model.discount !=0)
                   Text(
                     '${model.oldPrice.round()}',
                     maxLines: 2,
                     overflow: TextOverflow.ellipsis,
                     style:  const TextStyle(
                         fontSize: 14.0,
                         color:Colors.grey,
                       decoration: TextDecoration.lineThrough,
                     ),
                   ),
                   const Spacer(),
                   IconButton(
                       onPressed:(){
                         ShopCubit.get(context).changeFavorites(model.id!);
                         //print(model.id);
                       } ,
                       icon:CircleAvatar(
                         backgroundColor: ShopCubit.get(context).favorites[model.id]! ? defaultColor:Colors.grey,
                         child: const Icon(
                           Icons.favorite_border,
                         size: 22.0,
                           color: Colors.white,
                         ),
                       )
                   )
                 ],
              ),
            ],
          ),
        ),
      ],
    ),
  );


}
