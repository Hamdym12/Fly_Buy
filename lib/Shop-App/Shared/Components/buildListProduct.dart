import 'package:flutter/material.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Shared/Constants/Colors.dart';

Widget buildListProduct(model,context,{bool isOldPrice = true})=> Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image:  NetworkImage(model.image!),
              width: 120,
              height: 120,
            ),
            if(model.discount !=0 && isOldPrice)
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
        const SizedBox(width: 10,),
        Expanded(
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
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.price!.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14.0,
                        color:Colors.blue
                    ),
                  ),
                  const SizedBox(width: 7.0),
                  if(model.discount !=0 && isOldPrice)
                    Text(
                      model.oldPrice!.toString(),
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
                      } ,
                      icon: CircleAvatar(
                        backgroundColor: ShopCubit.get(context).favorites[model.id]!
                            ? defaultColor : Colors.grey,
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
  ),
);