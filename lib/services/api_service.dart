import 'dart:convert';
import '../models/bill.dart';

class ApiService {
  static Future<Bill?> fetchBill(String qrCode) async {
    // In production, make actual API call using qrCode
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Parse QR data instead of using mock data
      final Map<String, dynamic> qrData = jsonDecode(qrCode);
      return Bill.fromJson(qrData);
    } catch (e) {
      return null;
    }
  }
}