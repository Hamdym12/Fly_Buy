// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/Shop-App/Home_Layout/Home_Screen.dart';
import 'package:shop_app/Shop-App/Log-In/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Log-In/Cubit/States.dart';
import 'package:shop_app/Shop-App/Register/ShopRegisterScreen.dart';
import 'package:shop_app/Shop-App/Shared/Components/MyNavigator.dart';
import 'package:shop_app/Shop-App/Shared/Components/defaultButton.dart';
import 'package:shop_app/Shop-App/Shared/Components/defaultFormField.dart';
import 'package:shop_app/Shop-App/Shared/Components/defaultTextButton.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:shop_app/Shop-App/Shared/Components/showToast.dart';
import 'package:shop_app/Shop-App/Shared/Constants/constants.dart';
import 'package:shop_app/Shop-App/network/local/Cash_Helper.dart';

class ShopLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLogInCubit(),
      child: BlocConsumer<ShopLogInCubit, ShopLogInStates>(
        listener: (context, state) => {
          if (state is ShopLogInSuccessState)
            {
              if (state.loginModel.status!)
                {
                  //print(state.loginModel.message),
                  //print(state.loginModel.data!.token),

                  CacheHelper.saveData(// هنا بحفظ الداتا في الشيرد بيرفرنس وبخليه يروح لصفحه الهووم وميرجعش تاني
                      key: 'token',
                      value: state.loginModel.data!.token).
                  then((value) {
                    token = state.loginModel.data!.token;
                    //here i save the token again just in-case the token was 'killed'
                    NavigateAndFinish(context, const HomeLayoutScreen());
                  }),

                  showToast(
                      text: state.loginModel.message!,
                      state: ToastStates.SUCCESS
                  )
                }
              else
                {
                  print(state.loginModel.message),
                  showToast(
                      state:ToastStates.ERROR ,
                      text: state.loginModel.message!)
                }
            }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Image.asset('assets/images/carts.png',height: 40,width: 30,),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                              "LOGIN",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 35,
                                      color: Colors.black)),
                        ),
                        Center(
                          child: Text(
                              "Login now to explore our offers",
                              style:
                                  Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: Colors.grey,
                                        fontSize: 20,
                                      )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "please enter your email";
                            }
                          },
                          label: "Email Address",
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passController,
                          type: TextInputType.visiblePassword,
                          suffix: ShopLogInCubit.get(context).suffix,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLogInCubit.get(context).postLogin(
                                email: emailController.text,
                                password: passController.text,
                              );
                              /* ShopLogInCubit.get(context).userLogIn(
                                email: emailController.text,
                                password: passController.text,
                              );*/
                            }
                          },
                          isPassword: ShopLogInCubit.get(context).isPassword,
                          suffixPressed: () {
                            ShopLogInCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "password is too short";
                            }
                          },
                          label: "Password",
                          prefix: Icons.lock_outline,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLogInLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              print(emailController.text);
                              print(passController.text);
                              if (formKey.currentState!.validate()) {
                                ShopLogInCubit.get(context).postLogin(
                                  email: emailController.text,
                                  password: passController.text,
                                );
                                /*ShopLogInCubit.get(context).userLogIn(
                                    email: emailController.text,
                                    password: passController.text,
                                  );*/
                              }
                            },
                            isUpperCase: true,
                            text: "login",
                            radius: 10
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?",
                                style: TextStyle(fontWeight: FontWeight.w600,
                                fontSize: 15)),
                            defaultTextButton(
                                onPressed: () {
                                  NavigateTo(
                                      context, ShopRegisterScreen());
                                },
                                text:
                                 Text("REGISTER",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor
                                        )))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
