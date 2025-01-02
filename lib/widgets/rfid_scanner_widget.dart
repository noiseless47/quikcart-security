import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/security_provider.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class RFIDScannerWidget extends StatefulWidget {
  const RFIDScannerWidget({Key? key}) : super(key: key);

  @override
  _RFIDScannerWidgetState createState() => _RFIDScannerWidgetState();
}

class _RFIDScannerWidgetState extends State<RFIDScannerWidget> {
  bool isScanning = false;
  String? lastScannedTag;
  DateTime? lastScanTime;
  static const scanCooldown = Duration(seconds: 2); // Cooldown period between scans

  Future<void> startScanning(SecurityProvider provider) async {
    if (isScanning) return;

    setState(() => isScanning = true);

    try {
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        throw Exception('NFC not available');
      }

      while (isScanning) {
        var tag = await FlutterNfcKit.poll();
        String rfidTag = tag.id;

        // Check if this is the same tag and if enough time has passed
        final now = DateTime.now();
        if (rfidTag != lastScannedTag ||
            (lastScanTime != null && now.difference(lastScanTime!) > scanCooldown)) {

          // Update last scan info
          lastScannedTag = rfidTag;
          lastScanTime = now;
          var record = (await FlutterNfcKit.readNDEFRecords())[0];

          // Check if this is the same tag and if enough time has passed

            final str = record.toString();
            final regex = RegExp(r'text=([A-Za-z0-9]+)');
            // Match the input string
            final match = regex.firstMatch(str);

            final text = match!.group(1);
            print('Scanned RFID Tag: $text');
            provider.addScannedRFIDTag(text!);


          // Add a delay before the next scan
          await Future.delayed(const Duration(milliseconds: 500));
        }

        // Finish the polling cycle
        await FlutterNfcKit.finish();

        // Add a small delay before starting the next polling cycle
        await Future.delayed(const Duration(milliseconds: 300));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isScanning = false;
          lastScannedTag = null;
          lastScanTime = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityProvider>(
      builder: (context, provider, child) {
        if (provider.currentBill == null) {
          return const Center(child: Text('Please scan QR code first'));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: isScanning
                    ? () => setState(() => isScanning = false)
                    : () => startScanning(provider),
                child: Text(isScanning ? 'Stop Scanning' : 'Start RFID Scan'),
              ),
              if (isScanning)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    FlutterNfcKit.finish();
    super.dispose();
  }
}