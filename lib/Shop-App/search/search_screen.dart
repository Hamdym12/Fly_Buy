import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Shared/Components/buildListProduct.dart';
import 'package:shop_app/Shop-App/Shared/Components/defaultFormField.dart';
import 'package:shop_app/Shop-App/search/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/search/Cubit/States.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Image.asset('assets/images/carts.png',height:40,width: 30,),
              ),
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,top: 10,bottom: 20,right: 20),
                  child: Column(
                    children: [
                      defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        validate: (String? value){
                          if(value!.isEmpty){
                            return 'enter some thing to search for';
                          }
                          return null;
                        },
                        label: 'Search',
                        prefix: Icons.search,
                        onSubmit: (String? text){
                          SearchCubit.get(context).search(text!);
                        }
                      ),
                      const SizedBox(height: 10,),
                      if(state is SearchLoadingState)
                         const LinearProgressIndicator(),
                      const SizedBox(height: 10,),
                      if(state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => buildListProduct(SearchCubit.get(context).
                            searchModel!.data!.data[index],context,isOldPrice: false),
                            separatorBuilder: (context, index) => const Divider(),
                            itemCount: SearchCubit.get(context).searchModel!.data!.data.length),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
