import 'package:transcribe/config/config.dart';

import 'paragraph.dart'; // Import the Paragraph class

part 'paragraphs.g.dart'; // Generated Hive adapter file

@HiveType(typeId: 4) // Assign a unique typeId for this model
class Paragraphs extends HiveObject {
  @HiveField(0)
  final String transcript;

  @HiveField(1)
  final List<Paragraph>? paragraphs; // Nullable list of Paragraphs

  Paragraphs({
    required this.transcript,
    this.paragraphs,
  });

  // Factory constructor to create a Paragraphs from JSON
  factory Paragraphs.fromJson(Map<String, dynamic> json) {
    return Paragraphs(
      transcript: json['transcript'],
      paragraphs: json['paragraphs'] != null ? (json['paragraphs'] as List).map((paraJson) => Paragraph.fromJson(paraJson)).toList() : null, // Return null if 'paragraphs' is not present in the JSON
    );
  }

  // Convert Paragraphs to a map to store in Hive
  Map<String, dynamic> toJson() {
    return {
      'transcript': transcript,
      'paragraphs': paragraphs?.map((para) => para.toJson()).toList(),
    };
  }
}
