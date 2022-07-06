// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:shop_app/Shop-App/Shared/Components/MyNavigator.dart';
import 'package:shop_app/Shop-App/network/local/Cash_Helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Log-In/LogInScreen.dart';

class BoardingModel {
  final String image;
  final String body;
  final String title;

  BoardingModel({
    required this.image,
    required this.body,
    required this.title,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        image: "assets/images/don.jpg",
        body: "Cristiano Ronaldo",
        title: "On Board 1 Title"),
    BoardingModel(
      image: "assets/images/mkl.jpg",
      body: "Cristiano Ronaldo",
      title: "On Board 2 Title",
    ),
    BoardingModel(
      image: "assets/images/mot1.jpg",
      body: "Marcelo",
      title: "On Board 3 Title",
    ),
  ];
  bool isLast = false;

  void submit(){
    CacheHelper.saveData(
        key: 'onBoarding',
        value: true
    ).then((value) {
         if(value){
           NavigateAndFinish(context,  ShopLoginScreen());
         }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/carts.png',height: 40,width: 30,),
        actions: [
          TextButton(
              onPressed: submit ,
              child:  Padding(
                padding: const EdgeInsets.only(right: 5,bottom: 5),
                child: Text(
                  "SKIP",
                    style:  TextStyle(
                    fontSize: 25,
                        color: Theme.of(context).primaryColor
                ),),
              )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context, index) =>
                    BuildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) // دي بستخدمها عشان اتحقق اني وصلت لاخر الليست عشان اتنقل الي صفحه تانيه
                  {
                    setState(() {
                      isLast = true;
                    });
                    print("Last");
                  } else {
                    setState(() {
                      isLast = false;
                    });
                    print("Not Last");
                  }
                },
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: boarding.length,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    expansionFactor: 3,
                    dotWidth: 10,
                    spacing: 5,
                    activeDotColor: Color.fromRGBO(7,39,67, 1)
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (isLast) {// means that if isLast is true run 'submit' method//
                      submit();
                    }
                    else //means that if isLast is false go to the next page
                    {
                      boardController.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn,//غير في دي عشان تعمل انيمشن
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget BuildBoardingItem(BoardingModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Image(image: AssetImage(model.image), fit: BoxFit.cover),
        ),
        const SizedBox(height: 15.0),
        Text(
          model.title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15.0),
        Text(
          model.body,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }
}
