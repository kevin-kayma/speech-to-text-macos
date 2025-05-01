class Product {
  final String? title;
  final String? description;
  final String? price;
  final bool? inCollection;
  final String? productKind;
  final String? storeId;

  const Product({
    required this.title,
    required this.description,
    required this.price,
    required this.inCollection,
    required this.productKind,
    required this.storeId,
  });

  String? get formattedTitle {
    return toJson().toString();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(title: json['title'] as String?, description: json['description'] as String?, price: json['price'] as String?, inCollection: json['inCollection'] as bool?, productKind: json['productKind'] as String?, storeId: json['storeId'] as String?);
  }

  @override
  String toString() {
    return 'Product(title: $title, description: $description, price: $price, '
        'inCollection: $inCollection, productKind: $productKind, storeId: $storeId)';
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'inCollection': inCollection,
      'productKind': productKind,
      'storeId': storeId,
    };
  }
}
