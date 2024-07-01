import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dilvery/live_tracking/live_tracking.dart';
import 'package:dilvery/order_list/order_list_controller.dart';

class OrdersListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderListController>(
      init: OrderListController(),
      builder: (controller) {
        // Show loading indicator while fetching data
        if (controller.orders.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Order_List"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Order_List"),
          ),
          body: ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Order_ID : ${controller.orders[index].id}"),
                subtitle: Text("Customer : ${controller.orders[index].name}"),
                onTap: () {
                  Get.to(() => LiveTrackingPage(), arguments: {"order": controller.orders[index]});
                },
              );
            },
          ),
        );
      },
    );
  }
}
