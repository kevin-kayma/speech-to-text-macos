import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:transcribe/config/config.dart';
import 'package:transcribe/models/paragraph.dart';
import 'package:transcribe/models/paragraphs.dart';
import 'package:transcribe/models/responsemodel.dart';
import 'package:transcribe/models/sentence.dart';
import 'package:transcribe/models/transcriptionresponse.dart';

class ApiService {
  //Get Initiate Data
  static getInitData() async {
    try {
      bool isConnection = await Utils.checkInternet();
      if (isConnection) {
        var response = await http.get(
          Uri.parse(Platform.isAndroid ? strInitAndroidURL : strInitiOSURL),
        );

        final jsonResponse = jsonDecode(response.body);

        initAlertData = InitAlertData.fromJson(jsonResponse);
        Utils.checkReview();
      }
    } catch (e) {
      debugPrint("$e in getInitData");
    }
  }

  // Speech to text using Deepgram
  static Future<Responsemodel?> speechToTextDG(
      String filePath, String languageCode, BuildContext context) async {
    Utils.sendAnalyticsEvent(Keys.strAnlDeepgramProcess);
    try {
      // Check if the file exists
      File audioFile = File(filePath);
      if (!audioFile. existsSync()) {
        debugPrint("File does not exist at path: $filePath");
        return null;
      }

      Deepgram deepgram = Deepgram(deepLinkKey, baseQueryParams: {
        'model': 'nova-2-general',
        'filler_words': false,
        'punctuation': true,
        'paragraphs': true,
        'smart_format': true,
        if (languageCode.isNotEmpty)
          'language': languageCode
        else
          'detect_language': true,
      });

      debugPrint(filePath);
      DeepgramSttResult res = await deepgram.transcribeFromFile(audioFile);

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(res.json);

      // Check for errors in the JSON response
      if (jsonResponse.containsKey('err_code')) {
        Utils.sendErrorToSlack('Deepgram Error: ${jsonResponse['err_msg']}',
            statusCode: jsonResponse['err_code']);
        return null;
      }

      // Convert the response to ResTranscriptionResponse
      ResTranscriptionResponse transcriptionResponse =
          ResTranscriptionResponse.fromJson(jsonResponse);

      // Map the ResTranscriptionResponse to Responsemodel
      Responsemodel responseModel =
          mapResTranscriptionResponseToResponseModel(transcriptionResponse);

      Utils.sendAnalyticsEvent(Keys.strAnlDeepgramDone);
      return responseModel;
    } catch (e) {
      Utils.sendAnalyticsEvent(Keys.strAnlDeepgramCatch);
      debugPrint(e.toString());
      return null;
    }
  }

  static Responsemodel mapResTranscriptionResponseToResponseModel(
      ResTranscriptionResponse transcriptionResponse) {
    // Extract necessary data from ResTranscriptionResponse and map it
    final paragraphs = Paragraphs(
      transcript: transcriptionResponse.results.channels
          .expand((channel) => channel.alternatives)
          .map((alt) => utf8.decode(alt
              .transcript.codeUnits)) // Extract transcript from ResAlternative
          .join(" "), // Combine all alternative transcripts into one string
      paragraphs: transcriptionResponse.results.channels
          .expand((channel) => channel.alternatives) // Extract all alternatives
          .expand(
              (alt) => alt.paragraphs.paragraphs) // Extract all ResParagraphs
          .map((resParagraph) {
        // Map each ResParagraph to a Paragraph
        return Paragraph(
          sentences: resParagraph.sentences.map((resSentence) {
            return Sentence(
              text: utf8.decode(resSentence.text.codeUnits),
              confidence:
                  0.0, // Since 'confidence' isn't available, default to 0.0
            );
          }).toList(),
          numWords: resParagraph.numWords, // Get numWords directly
          start: resParagraph.start, // Get start time
          end: resParagraph.end, // Get end time
        );
      }).toList(), // Convert to List<Paragraph>
    );

    return Responsemodel(paragraphs: paragraphs);
  }
}
