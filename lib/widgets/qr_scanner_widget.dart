import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:security/route.dart';
import '../models/bill.dart';
import '../models/bill_item.dart';
import '../providers/security_provider.dart';
import '../services/api_service.dart';
import '../services/audio_service.dart';

class QRScannerWidget extends StatefulWidget {
  const QRScannerWidget({Key? key}) : super(key: key);

  @override
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  MobileScannerController? controller;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: isScanning
            ? MobileScanner(
          controller: controller!,
          onDetect: _onDetect,
        )
            : ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
          onPressed: () => setState(() => isScanning = true),
          child: const Text('Scan Bill QR Code'),
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.displayValue != null) {

        final payUri = Uri.parse("$host/api/bills/${barcode.displayValue}");
        final resp = await get(payUri);

        if(resp.statusCode != 200) {
          log("Failed to get the bill");
          return;
        }

        var js = jsonDecode(resp.body);
        var items = js['content'] as List;

        List<BillItem> billItems = [];

        for(var item in items) {
          billItems.add(
              BillItem(id: item['product_id'], name: item['product_id'], rfidTag: item['product_id'], price: double.parse("${item['quantity']}"))
          );
        }

        var bill = Bill(id: js['payment_id'], items: billItems, total: 0);
        isScanning = false;


        if (bill != null) {
          context.read<SecurityProvider>().setBill(bill);
          await AudioService.playSuccessBeep();
          setState(() => isScanning = false);
        } else {
          await AudioService.playErrorBeep();
        }
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}