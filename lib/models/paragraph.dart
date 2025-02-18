import 'package:hive/hive.dart';
import 'sentence.dart'; // Import Sentence model

part 'paragraph.g.dart'; // Generated Hive adapter file

@HiveType(typeId: 5)
class Paragraph extends HiveObject {
  @HiveField(0)
  final List<Sentence> sentences; // List of sentences

  @HiveField(1)
  final int numWords;

  @HiveField(2)
  final double start;

  @HiveField(3)
  final double end;

  Paragraph({
    required this.sentences,
    required this.numWords,
    required this.start,
    required this.end,
  });

  // Factory constructor to create a Paragraph from JSON
  factory Paragraph.fromJson(Map<String, dynamic> json) {
    return Paragraph(
      sentences: (json['sentences'] as List)
          .map((sentenceJson) => Sentence.fromJson(sentenceJson))
          .toList(),
      numWords: json['num_words'],
      start: json['start'].toDouble(),
      end: json['end'].toDouble(),
    );
  }

  // Convert Paragraph to a map to store in Hive
  Map<String, dynamic> toJson() {
    return {
      'sentences': sentences.map((sentence) => sentence.toJson()).toList(),
      'num_words': numWords,
      'start': start,
      'end': end,
    };
  }
}
