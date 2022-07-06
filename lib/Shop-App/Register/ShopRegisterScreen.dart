import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Home_Layout/Home_Screen.dart';
import 'package:shop_app/Shop-App/Log-In/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Log-In/Cubit/States.dart';
import 'package:shop_app/Shop-App/Log-In/LogInScreen.dart';
import 'package:shop_app/Shop-App/Register/Cubit/Cubit.dart';
import 'package:shop_app/Shop-App/Register/Cubit/States.dart';
import 'package:shop_app/Shop-App/Shared/Components/MyNavigator.dart';
import 'package:shop_app/Shop-App/Shared/Components/defaultButton.dart';
import 'package:shop_app/Shop-App/Shared/Components/defaultFormField.dart';
import 'package:shop_app/Shop-App/Shared/Components/defaultTextButton.dart';
import 'package:shop_app/Shop-App/Shared/Components/showToast.dart';
import 'package:shop_app/Shop-App/Shared/Constants/constants.dart';
import 'package:shop_app/Shop-App/network/local/Cash_Helper.dart';
class ShopRegisterScreen extends StatelessWidget {
   ShopRegisterScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
   var nameController = TextEditingController();
   var phoneController = TextEditingController();
   var emailController = TextEditingController();
   var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(BuildContext context)=>ShopRegisterCubit() ,
      child: BlocConsumer<ShopRegisterCubit,ShopRegisterStates>(
        listener: (context,state){
          if (state is ShopRegisterSuccessState)
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
              });

          showToast(
          text: state.loginModel.message!,
          state: ToastStates.SUCCESS
          );
          }
          else
          {
          print(state.loginModel.message);
          showToast(
          state:ToastStates.ERROR ,
          text: state.loginModel.message!);
          }
        }
        },
        builder:(context,state){
          return Scaffold(
            appBar: AppBar(),
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
                              "REGISTER",
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
                              "Register now to explore our offers",
                              style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Colors.grey,
                                fontSize: 20,
                              )),
                        ),
                        const SizedBox(height: 30,),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "please enter your name";
                            }
                          },
                          label: "Name",
                          prefix: Icons.person,
                        ),
                        const SizedBox(height: 20,),
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
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: passController,
                          type: TextInputType.visiblePassword,
                          suffix: ShopRegisterCubit.get(context).suffix,
                          onSubmit: (value) {

                          },
                          isPassword: ShopRegisterCubit.get(context).isPassword,
                          suffixPressed: () {
                            ShopRegisterCubit.get(context)
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
                        const SizedBox(height:20,),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "please enter your phone number";
                            }
                          },
                          label: "Phone",
                          prefix: Icons.phone,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                //print(emailController.text);
                                //print(passController.text);
                                if (formKey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                    phone:phoneController.text ,
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passController.text,
                                  );
                                  /*ShopRegisterCubit.get(context).userLogIn(
                                      email: emailController.text,
                                      password: passController.text,
                                    );*/
                                }
                              },
                              isUpperCase: true,
                              text: "register",
                              radius: 10
                          ),
                          fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            defaultTextButton(
                                onPressed: () {
                                  NavigateTo(
                                      context, ShopLoginScreen());
                                },
                                text:
                                 Text("LOGIN",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor)))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } ,
      ),
    );
  }
}
