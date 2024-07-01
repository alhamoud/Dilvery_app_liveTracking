import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dilvery/model/my_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';


class DeliveryBoyController extends GetxController{

  TextEditingController orderIdController = TextEditingController();
  final Location location = Location();

  String deliveryAddress="";
  String phoneNumber="";
  String amountCollect="";
//AMsterdam
  double customerLatitude=   52.37083215812296;
  double customerLongitude=  4.8491532093093515;
  //Tartus
  // double customerLatitude=   34.87701150840063;
  // double customerLongitude= 35.882343943245914;
  bool showDeliveryInfo =false;
  bool IsDeliveryStarted =false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference ordercollection;
  late final CollectionReference orderTrackingCollection;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  ordercollection = firestore.collection("order");
  orderTrackingCollection = firestore.collection("orderTracking");
  getLocationPermission();
  }

  getOrderById() async{
    try{
      String orderId = orderIdController.text;
      QuerySnapshot querySnapshot = await ordercollection.where("id",isEqualTo: orderId).get();

      if(querySnapshot.docs.isNotEmpty){
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String , dynamic>;
        print("Datat : $data");
        MyOrder order = MyOrder.fromJson(data);
        if(order != null){
          deliveryAddress= order.address;
          phoneNumber = order.phone;
          amountCollect= order.amount.toString();
          customerLatitude= order.latitude;
          customerLongitude=order.longitude;
          showDeliveryInfo=true;
          }
        update();
      }else{
        Get.snackbar("Error", "Order not found");
        return null;
      }
    }catch(e){
      Get.snackbar("Error", e.toString());
          return;
    }
  }

  Future<void> getLocationPermission() async{
    try{
      bool serviceEnabled = await location.serviceEnabled();
      if(!serviceEnabled){
        serviceEnabled= await location.requestService();
      if(!serviceEnabled) {
        return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if(permissionGranted == PermissionStatus.denied){
        permissionGranted = await location.requestPermission();
        if(permissionGranted != PermissionStatus.granted){
          return;
        }
      }
    }catch(e){
      print("Error getting location: $e");
    }
  }

  void startDelivery(){
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("Location Changed: ${currentLocation.latitude}, ${currentLocation.longitude}");
      //update order tracking location when location changes
      saveOrUpdateMyorderLocation(orderIdController.text , currentLocation.latitude?? 0, currentLocation.longitude?? 0);
    });
    location.enableBackgroundMode(enable:true);
  }

  Future<void> saveOrUpdateMyorderLocation(String orderId, double latitude, double longitude)async{
    try{
      final DocumentReference docRef = orderTrackingCollection.doc(orderId);

      // use a transaction to ensure atomic read and write
      await firestore.runTransaction((transaction)async{
        final DocumentSnapshot snapshot = await transaction.get(docRef);
        // Document exist so we update
        if(snapshot.exists){
          transaction.update(docRef, {
            "latitude":latitude ,
            "longitude":longitude,
          });
        }else{
          // document not exist , we creat it
          transaction.set(docRef, {
            "orderId": orderId,
            "latitude":latitude ,
            "longitude":longitude,
          });
        }
      });
    }catch(e){
      print("Error saving or updating order location: $e");
    }
  }
}