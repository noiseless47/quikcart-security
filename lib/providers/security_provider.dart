import 'package:flutter/foundation.dart';
import '../models/bill.dart';
import '../models/bill_item.dart';
import '../services/audio_service.dart';

class SecurityProvider with ChangeNotifier {
  Bill? _currentBill;
  Set<String> _scannedRFIDTags = {};
  Map<String, bool> _verificationStatus = {};

  Bill? get currentBill => _currentBill;
  Set<String> get scannedRFIDTags => _scannedRFIDTags;
  Map<String, bool> get verificationStatus => _verificationStatus;

  void setBill(Bill bill) {
    _currentBill = bill;
    _scannedRFIDTags.clear();
    _verificationStatus.clear();
    // Initialize verification status for each item
    for (var item in bill.items) {
      _verificationStatus[item.rfidTag] = false;
    }
    notifyListeners();
  }

  void addScannedRFIDTag(String tag) async {
    if (_currentBill == null) return;

    _scannedRFIDTags.add(tag);

    // Check if tag matches any unverified item
    bool itemFound = false;
    var index = 0;
    for (var item in _currentBill!.items) {
      if (item.rfidTag == tag) {
        // Update the verification status// Update the item's isVerified property
        itemFound = true;
        _currentBill!.items[index] = BillItem(
          id: item.id,
          name: item.name,
          price: item.price - 1.0,
          rfidTag: item.rfidTag
        );

        if(_currentBill!.items[index].price <= 0.0) {
          _currentBill!.items.removeAt(index);
        }
        await AudioService.playSuccessBeep();
        break;
      }
      index += 1;
    }

    // Play error sound if tag doesn't match any unverified item
    if (!itemFound) {
      await AudioService.playErrorBeep();
    }

    notifyListeners();
  }

  bool hasUnverifiedItems() {
    return _verificationStatus.values.any((verified) => !verified);
  }
}