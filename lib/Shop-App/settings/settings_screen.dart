import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Home_Layout/Cubit/States.dart';
import 'package:shop_app/Shop-App/Log-In/Cubit/States.dart';
import 'package:shop_app/Shop-App/Shared/Components/defaultButton.dart';
import 'package:shop_app/Shop-App/Shared/Components/defaultFormField.dart';
import 'package:shop_app/Shop-App/Shared/Components/showToast.dart';
import 'package:shop_app/Shop-App/Shared/Constants/constants.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessUpdateUserState){
          if(state.shopLoginModel.status!) {
            showToast(
              text: state.shopLoginModel.message!,
              state: ToastStates.SUCCESS
          );
          }else{
            showToast(
                text: state.shopLoginModel.message!,
                state: ToastStates.ERROR
            );
          }
        }
      },
      builder: (context, state) {
        var model = ShopCubit
            .get(context)
            .userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;
        return ConditionalBuilder(
          condition: ShopCubit
              .get(context)
              .userModel != null,
          fallback: (context) =>
          const Center(child: CircularProgressIndicator()),
          builder: (context) =>
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if(state is ShopLoadingUpdateUserState)
                        const SizedBox(height:20,),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (String? name) {
                            if (name!.isEmpty) {
                              return 'enter your name';
                            } else {
                              return null;
                            }
                          },
                          label: 'Name',
                          prefix: Icons.person,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String? email) {
                            if (email!.contains('@') && email.isEmpty) {
                              return 'please enter a valid email';
                            } else {
                              return null;
                            }
                          },
                          label: 'Email',
                          prefix: Icons.email_rounded,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (String? phone) {
                            if (phone!.isEmpty) {
                              return 'please enter your phone number';
                            } else {
                              return null;
                            }
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
                        const SizedBox(height: 20,),
                        defaultButton(
                            radius: 10,
                            function: () {
                              if(formKey.currentState!.validate()){
                                ShopCubit.get(context).updateUserData(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                );
                              }

                            },
                            text: "Update"
                        ),
                        const SizedBox(height: 20,),
                        defaultButton(
                          radius: 10,
                            function: () {
                              signOut(context);
                            },
                            text: "LogOut"
                        ),

                      ],
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }
}
