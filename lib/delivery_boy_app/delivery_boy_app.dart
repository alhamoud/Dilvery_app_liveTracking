import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dilvery/delivery_boy_app/delivery_boy_controller.dart';
class DeliveryBoyPage extends StatelessWidget {

  double lat = 45.521563;
  double lng = -122.677433;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryBoyController>(
        init: DeliveryBoyController(),
        builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Delivery Boy App"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Image(image: AssetImage("images/11.jpg"),
                height: 200,
                width: 200,),
              Text(
                "Enter My Order ID",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: controller.orderIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "My order Id",
                ),
              ),
              SizedBox(height: 16),
              Visibility(
                visible: !controller.showDeliveryInfo, // Change to true to show the button
                child: ElevatedButton(
                  onPressed: () async{
                    controller.getOrderById();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Submit"),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Visibility(
                visible: controller.showDeliveryInfo, // Change to true to show the details
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Delivery Address: ${controller.deliveryAddress}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Phone Number: ${controller.phoneNumber}",
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            onPressed: () {
                              //lunch the phone number with phone dialer
                              launchUrl(Uri.parse("tel:${controller.phoneNumber}"));
                            },
                            icon: Icon(Icons.call))
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Amount to Collect: \$ ${controller.amountCollect}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            launchUrl(
                                Uri.parse(
                                    'https://www.google.com/maps?q=${controller.customerLatitude},${controller.customerLongitude}'));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          icon: Icon(Icons.location_on),
                          label: Text("Show Location"),
                        ),
                        ElevatedButton(
                            onPressed: () {

                              controller.startDelivery();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Start Delivery"))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
