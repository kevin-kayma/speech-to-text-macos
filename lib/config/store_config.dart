import 'package:flutter/material.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/config/windows_iap.dart';
import 'package:transcribe/models/product.dart';
import 'package:transcribe/pages/pages.dart';

class StoreConfig {
  static final StoreConfig _instance = StoreConfig._internal();
  late WindowsIap _windowsIap;

  List<Product> productList = [];

  StoreConfig._internal();

  factory StoreConfig() {
    return _instance;
  }

  Future<void> refreshSubscription() async {
    final licenses = await _windowsIap.getAddonLicenses();
    final products = await getAvailableProducts();

    isUserSubscribed = products.any(
      (product) {
        final id = product.storeId;
        if (id == null || id.isEmpty) return false;
        final license = licenses.values.where((lc) => lc.inAppOfferToken == yearlyPlan || lc.inAppOfferToken == monthlyPlan).firstOrNull;
        return license != null && license.isActive;
      },
    );
  }

  bool _isInitialized = false;

  Future<void> initStore() async {
    if (_isInitialized) return;

    _windowsIap = WindowsIap();
    await _windowsIap.getAddonLicenses();
    productList = await _windowsIap.getProducts();
    await refreshSubscription();
    _isInitialized = true;
  }

  static Future<void> openPaywall(BuildContext context) async {
    try {
      final products = await StoreConfig().getAvailableProducts();

      // await StoreConfig().refreshSubscription();
      if (!isUserSubscribed) {
        showDialog(
          context: context,
          builder: (context) {
            return Subscription(products: products);
          },
        );
      }
    } catch (error, st) {
      debugPrint("Some Error While Getting Products => $error \n StackTrace => $st");
    }
  }

  /// Get Available Product List
  Future<List<Product>> getAvailableProducts({bool forceRefresh = false}) async {
    if (productList.isNotEmpty && !forceRefresh) return productList;

    try {
      productList = await _windowsIap.getProducts();
      return productList;
    } catch (error, st) {
      debugPrint("Error getting products: $error \n $st");
      return [];
    }
  }

  Future<List<String>> getAddonLicenses() async {
    try {
      final licences = await _windowsIap.getAddonLicenses();
      final licenceString = licences.entries.map((entry) => "Key:${entry.key} => Value: ${entry.value.toJson()}\n").toList();
      // LogService.log("Licence List => $licenceString");
      return licenceString;
    } catch (error, st) {
      debugPrint("Some Error While Getting Licences => $error \n StackTrace => $st");
      return [];
    }
  }

  /// Make a purchase
  Future<bool> purchaseItem(String productId) async {
    try {
      final result = await _windowsIap.makePurchase(productId);
      if (result == StorePurchaseStatus.succeeded) {
        debugPrint("Purchase successful");
        return true;
      } else {
        debugPrint("Purchase failed: $result");
        return false;
      }
    } catch (error, st) {
      debugPrint("Error While Purchasing: $error, \n StackTrace => $st");
      return false;
    }
  }

  /// Check Purchase
  Future<bool> isProductOwned(String storeId) async {
    try {
      final isPurchased = await _windowsIap.checkPurchase(storeId: storeId);
      return isPurchased;
    } catch (error, st) {
      debugPrint("Error: $error \n Stack Trace $st");
      return false;
    }
  }
}
