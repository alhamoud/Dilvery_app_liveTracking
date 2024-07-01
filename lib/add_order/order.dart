import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dilvery/order_list/order_list.dart';
import 'add_order_controller.dart';

class AddOrderPage extends StatelessWidget {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(  34.894178173639204, 35.881406894948555);

  Future<void> _goToMyPosition(AddOrderController controller) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    controller.mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddOrderController>(
      init: AddOrderController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Order Details"),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(()=> OrdersListPage());
                  },
                  icon: Icon(Icons.list)),
              IconButton(onPressed: () {}, icon: Icon(Icons.map_outlined))
            ],
          ),
          body: ListView(
            children: [
              TextField(
                controller: controller.orderIdController,
                decoration: InputDecoration(
                  labelText: "Order_ID",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: "Customer_Name",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  labelText: "Customer_Phone",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: controller.addressController,
                decoration: InputDecoration(
                  labelText: "Customer_Address",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: controller.amountController,
                decoration: InputDecoration(
                  labelText: "Bill_Amount",
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                width: 500,
                height: 500,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:  LatLng(34.89311206510446, 35.88085384241993),
                    zoom: 11.0,
                  ),
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  mapToolbarEnabled: true,
                  onMapCreated: (GoogleMapController mapController) {
                    controller.mapController = mapController;
                  },
                  onTap: (latlong) {
                    controller.selectedLocation = latlong;
                    controller.update();
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId("Selected_Location"),
                      position: controller.selectedLocation,
                      infoWindow: InfoWindow(
                        title: "Selected_Location",
                        snippet: "lat: ${controller.selectedLocation.latitude}, lng: ${controller.selectedLocation.longitude}",
                      ),
                    )
                  },
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  controller.addOrder(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text("Submit order"),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _goToMyPosition(controller),
            child: Icon(Icons.my_location),
          ),
        );
      },
    );
  }
}
