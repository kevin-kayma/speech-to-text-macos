import 'package:hive/hive.dart';
import 'paragraphs.dart'; // Import Paragraphs class

part 'responsemodel.g.dart'; // Generated Hive adapter file

@HiveType(typeId: 3) // Assign a unique typeId for this model
class Responsemodel extends HiveObject {
  @HiveField(0)
  final Paragraphs paragraphs; // A single Paragraphs object

  Responsemodel({
    required this.paragraphs,
  });

  // Factory constructor to create a Responsemodel from JSON
  factory Responsemodel.fromJson(Map<String, dynamic> json) {
    return Responsemodel(
      paragraphs: Paragraphs.fromJson(json),
    );
  }

  // Convert Responsemodel to a map to store in Hive
  Map<String, dynamic> toJson() {
    return {
      'paragraphs': paragraphs.toJson(),
    };
  }
}
