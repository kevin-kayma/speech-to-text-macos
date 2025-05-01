class StoreLicense {
  final bool isActive;
  final String? skuStoreId;
  final String? inAppOfferToken;
  final num? expirationDate;

  const StoreLicense({
    this.isActive = false,
    this.skuStoreId,
    this.inAppOfferToken,
    this.expirationDate,
  });

  /// get Expiration date in DateTime format.
  DateTime? getExpirationDate() {
    if (expirationDate == null) {
      return null;
    }

    var magic = num.tryParse(expirationDate.toString().substring(0, 14));
    if (magic == null) {
      return null;
    }
    magic = magic - 11644499200000;
    return DateTime.fromMillisecondsSinceEpoch(magic.toInt());
  }

  factory StoreLicense.fromJson(Map<String, dynamic> json) {
    return StoreLicense(
      isActive: json['isActive'] ?? false,
      skuStoreId: json['skuStoreId'],
      inAppOfferToken: json['inAppOfferToken'],
      expirationDate: json['expirationDate'],
    );
  }

  @override
  String toString() {
    return 'StoreLicense(isActive: $isActive, skuStoreId: $skuStoreId, '
        'inAppOfferToken: $inAppOfferToken, expirationDate: ${getExpirationDate()})';
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'skuStoreId': skuStoreId,
      'inAppOfferToken': inAppOfferToken,
      'expirationDate': expirationDate,
    };
  }
}
