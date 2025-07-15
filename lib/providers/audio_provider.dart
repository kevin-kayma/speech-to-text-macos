// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:transcribe/apis/network.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/extension/string_extension.dart';
import 'package:transcribe/models/chat_message.dart';
import 'package:transcribe/models/models.dart';
import 'package:transcribe/models/responsemodel.dart';
import 'package:transcribe/pages/pages.dart';
import 'package:transcribe/providers/providers.dart';

final isAudioLoadingProvider = StateProvider<bool>((ref) => false);
final isVoiceRecordLoadingProvider = StateProvider<bool>((ref) => false);
final strAudioFileLanguageProvider = StateProvider<String>((ref) => '');
final audioListProvider = StateNotifierProvider<AudioListNotifier, List<AudioModel>>(
  (ref) => AudioListNotifier(),
);

class AudioListNotifier extends StateNotifier<List<AudioModel>> {
  AudioListNotifier() : super([]) {
    loadAudioHistory();
  }

  Future<void> addChatMessage(int audioId, ChatMessage newMessage) async {
    final audio = getAudioById(audioId);
    if (audio == null) return;

    final updatedChatList = <ChatMessage>[...(audio.chatList ?? []), newMessage];
    final updatedAudio = audio.copyWith(chatList: updatedChatList);
    await updateAudio(updatedAudio);
  }

  Future<void> updateMessageList(int audioId, List<ChatMessage> newMessage) async {
    final audio = getAudioById(audioId);
    if (audio == null) return;

    final updatedAudio = audio.copyWith(chatList: newMessage);
    await deleteAudio(audioId);
    await addAudio(updatedAudio);
  }

  Future<void> updateChatMessage({
    required int audioId,
    required int index,
    required ChatMessage updatedMessage,
  }) async {
    final audio = getAudioById(audioId);
    if (audio == null || audio.chatList == null || index >= audio.chatList!.length) return;

    final chatList = <ChatMessage>[...(audio.chatList ?? [])];
    chatList[index] = updatedMessage;

    final updatedAudio = audio.copyWith(chatList: chatList);
    await updateAudio(updatedAudio);
  }

  Future<void> deleteChatMessage({
    required int audioId,
    required int index,
  }) async {
    final audio = getAudioById(audioId);
    if (audio == null || audio.chatList == null || index >= audio.chatList!.length) return;

    final chatList = <ChatMessage>[...audio.chatList!]..removeAt(index);
    final updatedAudio = audio.copyWith(chatList: chatList);
    await updateAudio(updatedAudio);
  }

  void loadAudioHistory() {
    final audioBox = Boxes.getAudio();
    final audio = audioBox.get(Keys.keyAudioID);
    if (audio is UserAudioHistory) {
      state = audio.audioList.toList();
    }
  }

  Future<void> updateAudio(AudioModel updatedAudioModel) async {
    state = [
      for (final audio in state)
        if (audio.id == updatedAudioModel.id) updatedAudioModel else audio,
    ];
    final audioHistory = UserAudioHistory()..audioList = state;
    final audioBox = Boxes.getAudio();
    await audioBox.put(Keys.keyAudioID, audioHistory);
  }

  Future<void> addAudio(AudioModel audioModel) async {
    state = [...state, audioModel];
    final audioHistory = UserAudioHistory()..audioList = state;
    final audioBox = Boxes.getAudio();
    await audioBox.put(Keys.keyAudioID, audioHistory);
  }

  Future<void> deleteAudio(int audioId) async {
    state = state.where((audio) => audio.id != audioId).toList();
    final audioHistory = UserAudioHistory()..audioList = state;
    final audioBox = Boxes.getAudio();
    await audioBox.put(Keys.keyAudioID, audioHistory);
  }

  AudioModel? getAudioById(int audioId) {
    try {
      return state.firstWhere((audio) => audio.id == audioId);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAudioHistory() async {
    state = [];
    final audioBox = Boxes.getAudio();
    await audioBox.clear();
  }

  Future<void> pickAndAddAudio(
    WidgetRef ref,
    BuildContext context,
  ) async {
    try {
      bool isConnected = await Utils.checkInternet();
      if (!isConnected) {
        Utils.noNetworkDialog(
          context,
          onRetry: () async {
            Navigator.of(context).pop();
            await pickAndAddAudio(ref, context);
          },
        );
        return;
      }

      await Utils.refreshSubscription();
      if (!Utils.isCanAccess(CanAccess.audio)) {
        StoreConfig.showSubscription(context);
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['m4a', 'mp3', 'webm', 'mpga', 'wav', 'mpeg'],
      );

      if (result != null) {
        final path = result.files.single.path ?? '';
        final file = File(path);
        double fileSizeMB = file.lengthSync() / (1024 * 1024);

        if (fileSizeMB >= 25 && !isUserSubscribed) {
          StoreConfig.showSubscription(context);
          return;
        }

        ref.read(isAudioLoadingProvider.notifier).state = true;
        final languageCode = ref.read(strAudioFileLanguageProvider);

        Responsemodel? responsemodel = await ApiService.speechToTextDG(
          path,
          languageCode,
          context,
        );

        ref.read(isAudioLoadingProvider.notifier).state = false;
        if (responsemodel?.paragraphs.transcript.removeWhiteSpace == "" || responsemodel == null) {
          Utils.errorFeedbackDialog(context);
          return;
        }

        final user = ref.read(userProvider.notifier).state.getUser;

        Utils.addUser(intAudio: (user.intAudio ?? 0) + 1);

        String filename = basename(path);
        final audioModel = AudioModel(
          id: DateTime.now().millisecondsSinceEpoch,
          filename: filename,
          filePath: path,
          date: Utils.getCurrentDateAndTime(),
          responseModel: responsemodel,
        );

        await addAudio(audioModel);
        if ([2, 4, 6, 8, 13].contains(user.intAudio)) {
          Utils.reviewDialog(context).then((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioDetail(audioModel: audioModel),
              ),
            );
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioDetail(audioModel: audioModel),
            ),
          );
        }
      }
    } catch (e) {
      ref.read(isAudioLoadingProvider.notifier).state = false;
    }
  }
}
