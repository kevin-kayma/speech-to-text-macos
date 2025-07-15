import 'dart:convert';


extension MapWithConditionalJsonEncode on Map<String, dynamic> {

  dynamic encodeIfNeeded(bool shouldEncode) {
    if (shouldEncode) {
      return jsonEncode(this);
    } else {
      return this;
    }
  }
}
