import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_order/order.dart';
import 'package:get/get.dart';
import 'package:dilvery/delivery_boy_app/delivery_boy_app.dart';
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: (){
              Get.to(AddOrderPage());
            },
            child: Text("Client app")),
        SizedBox(height: 20.0,),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: (){
              Get.to(DeliveryBoyPage());
            },
            child: Text("Dilvery boy app")),
      ],
    );
  }
}
