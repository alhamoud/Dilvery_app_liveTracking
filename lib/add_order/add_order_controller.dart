import 'package:dilvery/model/my_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrderController extends GetxController{

  TextEditingController orderIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  GoogleMapController? mapController;
  LatLng currentLocation= LatLng(0, 0);
  LatLng selectedLocation= LatLng(0, 0);

  FirebaseFirestore firestore= FirebaseFirestore.instance;
  late CollectionReference orderCollection;
  List<MyOrder> orders=[];
  @override
  Future<void> onInit()async {
    // TODO: implement onInit
    orderCollection=firestore.collection("order");
    super.onInit();

  }


  void addOrder(BuildContext context){
    try{
      if(nameController.text.isEmpty||orderIdController.text.isEmpty||addressController.text.isEmpty){
       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill field")));
        Get.snackbar("please fill The field", "UnSuccessfuly");
        return;
      }else{

        DocumentReference doc = orderCollection.doc(orderIdController.text);

        MyOrder order = MyOrder(

            id: doc.id,
            name: nameController.text,
            phone: phoneController.text,
            address: addressController.text,
            latitude: selectedLocation!.latitude.toDouble(),
            longitude: selectedLocation!.longitude.toDouble(),
            amount: double.parse(amountController.text,)
        );
        final orderJson= order.toJson();
        doc.set(orderJson);
        clearTextFields();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("order added successfully")));
        }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add order")));
      rethrow;

    }
  }

   clearTextFields() {
     orderIdController.clear();
     nameController.clear();
     phoneController.clear();
     addressController.clear();
     amountController.clear();
   }


}