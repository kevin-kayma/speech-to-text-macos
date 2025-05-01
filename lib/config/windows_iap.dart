import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:transcribe/models/product.dart';
import 'package:transcribe/models/store_license.dart';

const _escapeMap = {
  '\n': '',
  '\r': '',
  '\f': '',
  '\b': '',
  '\t': '',
  '\v': '',
  '\x7F': '', // delete
};

List<T> parseListNotNull<T extends Object?>({
  required List<dynamic> json,
  required T Function(Map<String, dynamic> json) fromJson,
}) {
  return (json).map((e) => fromJson(e as Map<String, dynamic>)).toList();
}

/// A [RegExp] that matches whitespace characters that should be escaped.
var _escapeRegExp = RegExp('[\\x00-\\x07\\x0E-\\x1F${_escapeMap.keys.map(_getHexLiteral).join()}]');

/// Returns [str] with all whitespace characters represented as their escape
/// sequences.
///
/// Backslash characters are escaped as `\\`
String escape(String str) {
  str = str.replaceAll('\\', r'\\');
  return str.replaceAllMapped(_escapeRegExp, (match) {
    var mapped = _escapeMap[match[0]];
    if (mapped != null) return mapped;
    return _getHexLiteral(match[0]!);
  });
}

/// Given single-character string, return the hex-escaped equivalent.
String _getHexLiteral(String input) {
  var rune = input.runes.single;
  return r'\x' + rune.toRadixString(16).toUpperCase().padLeft(2, '0');
}

enum StorePurchaseStatus {
  succeeded,
  alreadyPurchased,
  notPurchased,
  networkError,
  serverError,
}

class WindowsIap {
  final methodChannel = const MethodChannel('windows_iap');

  Future<StorePurchaseStatus?> makePurchase(String storeId) async {
    final result = await methodChannel.invokeMethod<int>('makePurchase', {'storeId': storeId});
    if (result == null) {
      return null;
    }
    switch (result) {
      case 0:
        return StorePurchaseStatus.succeeded;
      case 1:
        return StorePurchaseStatus.alreadyPurchased;
      case 2:
        return StorePurchaseStatus.notPurchased;
      case 3:
        return StorePurchaseStatus.networkError;
      case 4:
        return StorePurchaseStatus.serverError;
    }
    return null;
  }

  Stream<List<Product>> productsStream() {
    return const EventChannel('windows_iap_event_products').receiveBroadcastStream().map((event) {
      if (event is String) {
        return parseListNotNull(json: jsonDecode(escape(event)), fromJson: Product.fromJson);
      } else {
        return [];
      }
    });
  }

  /// throw PlatformException if error
  Future<List<Product>> getProducts() async {
    final result = await methodChannel.invokeMethod<String>('getProducts');
    if (result == null) {
      return [];
    }
    return parseListNotNull(json: jsonDecode(escape(result)), fromJson: Product.fromJson);
  }

  /// Check when user has current valid purchase
  ///
  /// - Add-On type: Subscription, Durable
  ///
  /// - Always return false if AppLicense has IsActive status = false.
  ///
  /// - if storeId is Not Empty:
  ///
  /// -- it will return true if Product(storeId) has IsActive status = true.
  ///
  /// -- return false if not.
  ///
  /// - if storeId is Empty:
  ///
  /// -- it will return true if any Add-On have IsActive status = true.
  ///
  /// -- return false if all Add-On have IsActive status = false.
  Future<bool> checkPurchase({required String storeId}) async {
    final result = await methodChannel.invokeMethod<bool>('checkPurchase', {'storeId': storeId});
    return result ?? false;
  }

  /// return the map of StoreLicense
  ///
  /// A map of key and value pairs, where each key is the Store ID of an add-on SKU from the
  /// Microsoft Store catalog and each value is a StoreLicense object that contains license
  /// info for the add-on.
  Future<Map<String, StoreLicense>> getAddonLicenses() async {
    final result = await methodChannel.invokeMethod<Map>('getAddonLicenses');
    if (result == null) {
      return {};
    }
    return result.map((key, value) => MapEntry(key.toString(), StoreLicense.fromJson(jsonDecode(value))));
  }
}
