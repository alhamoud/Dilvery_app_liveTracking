import 'package:dilvery/model/my_order.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderListController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  List<MyOrder> orders = [];

  @override
  Future<void> onInit() async {
    orderCollection = firestore.collection("order");
    await getAllOrder();
    super.onInit();
  }

  Future<void> getAllOrder() async {
    try {
      QuerySnapshot querySnapshot = await orderCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Document data: $data');  // Debugging line
        MyOrder order = MyOrder.fromJson(data);
        orders.add(order);
      }
      update();
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }
}
