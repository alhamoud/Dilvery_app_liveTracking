class MyOrder {
  final String id;
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final double amount;

  MyOrder({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.amount,
  });

  factory MyOrder.fromJson(Map<String, dynamic> json) {
    return MyOrder(
      id: json['id']?? "",
      name: json['name']?? "",
      phone: json['phone']?? "",
      address: json['address']?? "",
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  // Method to convert an instance to Firestore data
  Map<String, dynamic> toJson() {
    return {
      'id'  : id ,
      'name': name,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'amount': amount,
    };
  }
}
