// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transcribe/apis/network.dart';
import 'package:transcribe/config/constants.dart';
import 'package:transcribe/config/strings.dart';
import 'package:transcribe/models/chat_model.dart';

final homeController = ChangeNotifierProvider(
  (ref) => HomeController(),
);

class HomeController extends ChangeNotifier {
  Tile selectedTile = Tile.record;
  List<ChatModel> chatList = [];
  void updateSelectedTile(Tile tile) {
    selectedTile = tile;
    currentSource = selectedTile == Tile.record ? Source.home : Source.history;
    notifyListeners();
  }

  bool isSummaryGenerating = false;

  void resetVariables() {
    chatList.clear();
    isSummaryGenerating = false;
    notifyListeners();
  }

  Future<String> generateSummary(BuildContext context, String transcription) async {
    if (transcription.trim().isEmpty) {
      return '';
    }
    isSummaryGenerating = true;
    notifyListeners();
    try {
      List<Map<String, dynamic>> contentList = [];

      String combinedPrompt = buildSummaryPrompt(transcription);

      contentList.add({"type": "text", "text": combinedPrompt});

      Map<String, dynamic> payload = {
        "model": chatGPTImageModel,
        "messages": [
          {"role": "user", "content": contentList},
        ],
        "max_tokens": 300,
      };

      chatList = await ApiService.sendMessageServerSide(payload: payload, context: context);

      isSummaryGenerating = false;
      notifyListeners();
      return chatList.last.msg;
    } catch (e) {
      debugPrint('Error generating summary: $e');
      isSummaryGenerating = false;
      notifyListeners();
      return '';
    }
  }

  String buildSummaryPrompt(String transcription) {
    StringBuffer prompt = StringBuffer();

    prompt.writeln("Please generate a concise summary based on the following information:");

    if (transcription.trim().isNotEmpty) {
      prompt.writeln("\n**Transcription:**");
      prompt.writeln(transcription.trim());
    }

    prompt.writeln("\n**Instructions:**");
    prompt.writeln("- Provide a brief, clear summary");
    prompt.writeln("- Highlight key points from both the message and transcription");
    prompt.writeln("- Keep the summary concise and informative");

    return prompt.toString();
  }
}

enum Tile {
  record,
  history,
}
