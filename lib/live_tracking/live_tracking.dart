import 'package:dilvery/model/my_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'live_tracking_controller.dart';
class LiveTrackingPage extends StatelessWidget {
  const LiveTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {

    Map<String,dynamic> arg = Get.arguments;
    MyOrder order= arg["order"];

    return GetBuilder<LiveTrackingController>(
      init: LiveTrackingController(),
        builder: (controller) {
        if(controller.myOrder==null){
          controller.myOrder=order;
          controller.updateCurrentLocation(order.latitude, order.longitude);
          controller.startTracking(order.id);
        }

      return Scaffold(
        appBar: AppBar(
          title: Text("Order Tracking"),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0)),

              child: GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: (mpCtrl) {
                  controller.mapController = mpCtrl;
                  controller.updateUiWithLocation(controller.deliveryBoyLocation.longitude, controller.deliveryBoyLocation.latitude);
                  },
                  initialCameraPosition: CameraPosition(
                    target: controller.destination,
                    zoom: 14.0,
                  ),
                markers: {
                    Marker(
                        markerId: MarkerId("destination"),
                        position: controller.destination,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                      infoWindow: InfoWindow(
                        title: "Destination",
                        snippet: "lat: ${controller.destination.latitude}, lng ${controller.destination.longitude}",
                        ),
                    ),
                    Marker(
                    markerId: MarkerId("Delivery Boy"),
                    position: controller.deliveryBoyLocation,
                      icon: controller.markerIcon,
                      infoWindow: InfoWindow(
                      title: "Delivery Boy",
                      snippet: "lat: ${controller.deliveryBoyLocation.latitude}, lng ${controller.deliveryBoyLocation.longitude}",
                    ),
                  ),

                },
              ),
            ),
            Positioned(
                top: 16.0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.yellow,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text("Remeaning Distance: ${controller.remainingDistance.toStringAsFixed(2)} KM"
                      , style: TextStyle(fontSize: 16.0),),
                  ),
                ))
          ],
        ),
      );
    });
  }
}

