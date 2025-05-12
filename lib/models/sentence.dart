import 'package:transcribe/config/config.dart';

part 'sentence.g.dart'; // Generated Hive adapter file

@HiveType(typeId: 6)
class Sentence extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final double confidence;

  Sentence({
    required this.text,
    required this.confidence,
  });

  // Factory constructor to create a Sentence from JSON
  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      text: json['text'],
      confidence: json['confidence'].toDouble(),
    );
  }

  // Convert Sentence to a map to store in Hive
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'confidence': confidence,
    };
  }
}
