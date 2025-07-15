// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:transcribe/components/error.dart';

import 'package:transcribe/config/config.dart';
import 'package:transcribe/models/chat_model.dart';
import 'package:transcribe/models/paragraph.dart';
import 'package:transcribe/models/paragraphs.dart';
import 'package:transcribe/models/responsemodel.dart';
import 'package:transcribe/models/sentence.dart';
import 'package:transcribe/models/serversidemodel.dart';
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

  static Future<Responsemodel?> speechToTextDG(
    String filePath,
    String languageCode,
    BuildContext context,
  ) async {
    Utils.sendAnalyticsEvent(AnalyticsEvents.deepgramProcess);

    final file = File(filePath);
    if (!file.existsSync()) {
      final msg = 'Audio file not found: $filePath';
      debugPrint(msg);
      showToast(msg);
      return null;
    }

    try {
      final deepgram = Deepgram(
        deepLinkKey,
        baseQueryParams: {
          'model': 'nova-2-general',
          'filler_words': false,
          'punctuation': true,
          'paragraphs': true,
          'smart_format': true,
          if (languageCode.isNotEmpty) 'language': languageCode else 'detect_language': true,
        },
      );

      final dgResult = await deepgram.transcribeFromFile(file);
      final Map<String, dynamic> json;
      try {
        json = jsonDecode(dgResult.json);
      } on FormatException catch (e) {
        debugPrint('Deepgram JSON parse error ${e.message}');
        showToast('Transcription failed. Please try again.');
        return null;
      }

      debugPrint(dgResult.json);

      if (json.containsKey('err_code')) {
        Utils.sendErrorToSlack('Deepgram Error: ${json['err_msg']}', statusCode: json['err_code']);
        showToast('Transcription service error (${json['err_code']}).');
        return null;
      }

      final transResponse = ResTranscriptionResponse.fromJson(json);
      final respModel = mapResTranscriptionResponseToResponseModel(transResponse);

      final rawTranscript = respModel.paragraphs.transcript.trim();
      final looksEmpty = rawTranscript.isEmpty || rawTranscript.replaceAll(RegExp(r'[\n\r\s]'), '').isEmpty;

      if (looksEmpty) {
        showToast('Could not detect any speech in this audio.');
        return null;
      }

      Utils.sendAnalyticsEvent(AnalyticsEvents.deepgramDone);
      return respModel;
    } catch (e, stack) {
      Utils.sendAnalyticsEvent(AnalyticsEvents.deepgramCatch);
      debugPrintStack(stackTrace: stack);
      showToast('Unexpected error while transcribing.');
      return null;
    }
  }

  static Responsemodel mapResTranscriptionResponseToResponseModel(ResTranscriptionResponse transcriptionResponse) {
    final paragraphs = Paragraphs(
      transcript: transcriptionResponse.results.channels
          .expand((channel) => channel.alternatives)
          .map((alt) => utf8.decode(alt.transcript.codeUnits))
          .join(" "),
      paragraphs: transcriptionResponse.results.channels
          .expand((channel) => channel.alternatives)
          .expand((alt) => alt.paragraphs.paragraphs)
          .map(
        (resParagraph) {
          return Paragraph(
            sentences: resParagraph.sentences.map((resSentence) {
              return Sentence(
                text: utf8.decode(resSentence.text.codeUnits),
                confidence: 0.0,
              );
            }).toList(),
            numWords: resParagraph.numWords,
            start: resParagraph.start,
            end: resParagraph.end,
          );
        },
      ).toList(), // Convert to List<Paragraph>
    );

    return Responsemodel(paragraphs: paragraphs);
  }

  static Future<void> fetchAndSetServerAPIKey() async {
    try {
      bool isConnection = await Utils.checkInternet();
      if (isConnection) {
        final Map<String, String> headers = {
          Keys.keyContentType: Keys.keyApplicationJson,
          Keys.keyClientSecret: Utils.getDecodedSecretKey(EnvKeys.secretKey),
        };
        final response = await http.post(
          Uri.parse(urlSwGetToken),
          headers: headers,
          // body: jsonEncode(requestBody),
        );

        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        if (response.statusCode == StatusCode.success && jsonResponse[Keys.keyCode] == StatusCode.success) {
          serverAPIKey = jsonResponse[Keys.keyData][Keys.keyToken];
        } else {
          Utils.sendErrorToSlack(
            'Failed to fetch server API key: ${jsonResponse['message']} //in fetchAndSetServerAPIKey',
            statusCode: jsonResponse[Keys.keyCode].toString(),
          );
          return;
        }
      } else {
        return;
      }
    } catch (error) {
      debugPrint("$error in  fetchAndSetServerAPIKey");
      return;
      // Handle error as needed
    }
  }

  static Future<List<ChatModel>> sendMessageServerSide({
    required Map<String, dynamic> payload,
    required BuildContext context,
  }) async {
    if (serverAPIKey != '') {
      var response = await http.post(
        Uri.parse(urlSwVision),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $serverAPIKey'},
        body: jsonEncode(payload),
      );

      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse[Keys.keyCode] == StatusCode.success) {
        ServerChatResponseModel serverResponse = ServerChatResponseModel.fromJson(jsonResponse[Keys.keyData]);

        return serverResponse.choices.map((choice) {
          return ChatModel(msg: choice.message.content, chatIndex: 1, isUser: false);
        }).toList();
      } else {
        showToast('msg');
        return [];
      }
    } else {
      await fetchAndSetServerAPIKey();
      failedAttemptServer++;
      if (failedAttemptServer < maxFailedAttemptServer) {
        return await sendMessageServerSide(payload: payload, context: context);
      } else {
        showToast("Something Went Wrong");
        Utils.sendErrorToSlack("Server Key Is Not Fetched //ServerError in sendMessageServerSide", statusCode: 'Null');
        return [];
      }
    }
  }
}
