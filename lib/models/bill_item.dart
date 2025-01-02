class BillItem {
  final String id;
  final String name;
  final String rfidTag;
  final double price;
  bool isVerified;

  BillItem({
    required this.id,
    required this.name,
    required this.rfidTag,
    required this.price,
    this.isVerified = false,
  });

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      id: json['id'],
      name: json['name'],
      rfidTag: json['rfidTag'],
      price: json['price'].toDouble(),
    );
  }
}