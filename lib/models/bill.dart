import 'bill_item.dart';
class Bill {
  final String id;
  final List<BillItem> items;
  final double total;

  Bill({
    required this.id,
    required this.items,
    required this.total,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => BillItem.fromJson(item))
          .toList(),
      total: json['total'].toDouble(),
    );
  }
}