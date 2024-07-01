import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dilvery/model/my_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class LiveTrackingController extends GetxController {

  MyOrder? myOrder;
  String orderId = "0000";

  LatLng destination = LatLng(10.2929726, 76.1645936);
  LatLng deliveryBoyLocation = LatLng(10.3225, 76.1526);
  GoogleMapController? mapController;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet);
  double remainingDistance = 0.0;
  final Location location = Location();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderTrackingCollection;

  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit
    orderTrackingCollection = firestore.collection("orderTracking");
    addCustomMarker();
  }

  void addCustomMarker() async {
    ImageConfiguration configuration = const ImageConfiguration(devicePixelRatio: 2.5);

    try {
      BitmapDescriptor customMarker= await BitmapDescriptor.fromAssetImage(configuration, " /images/food_icon_png.jpg");
        markerIcon =customMarker;
        update();
    } catch (e) {
      print('Error loading custom marker: $e');
    }
  }

  void updateCurrentLocation(double latitude, double longitude){
    destination= LatLng(latitude,longitude);
      update();
  }

  void startTracking(String orderId){

    if(orderId.isEmpty){
      print("Error: order ID is Empty");
      return;
    }

    try{
    orderTrackingCollection.doc(orderId).snapshots().listen((snapshot) {
      if(snapshot.exists){
        var trackingData = snapshot.data() as Map<String, dynamic>;
        double latitude = trackingData["latitude"];
        double longitude = trackingData["longitude"];
        updateUiWithLocation(longitude,latitude);
        print("latestLocation: $latitude, $longitude");
      }else{
        print("No tracking data available for order ID : $orderId");
      }
    });
    }catch(e){
      print('Error starting tracking: $e');
      rethrow;
    }
  }

  void updateUiWithLocation(double longitude,double latitude) {
      deliveryBoyLocation = LatLng(latitude, longitude);
      //Update the camera position to the new location
      mapController?.animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation));
      calculateRemainingDistance();
      update();

  }

  void calculateRemainingDistance(){
    double distance = Geolocator.distanceBetween(
        deliveryBoyLocation.latitude,
        deliveryBoyLocation.longitude,
        destination.latitude,
        destination.longitude
    );
    //convert distance from ,eters to kilometers
    double distanceInKm= distance/1000;
    remainingDistance= distanceInKm;
    print("Remaining Distance: $distanceInKm kilometers");
    update();
  }
}
