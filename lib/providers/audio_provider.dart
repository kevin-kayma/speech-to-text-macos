import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:transcribe/apis/network.dart';
import 'package:transcribe/components/components.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/models/models.dart';
import 'package:transcribe/models/paragraphs.dart';
import 'package:transcribe/models/responsemodel.dart';
import 'package:transcribe/providers/providers.dart';

final isAudioLoadingProvider = StateProvider<bool>((ref) => false);
final isVoiceRecordLoadingProvider = StateProvider<bool>((ref) => false);
final strAudioFileLanguageProvider = StateProvider<String>((ref) => '');
final audioListProvider =
    StateNotifierProvider<AudioListNotifier, List<AudioModel>>(
  (ref) => AudioListNotifier(),
);

class AudioListNotifier extends StateNotifier<List<AudioModel>> {
  AudioListNotifier() : super([]) {
    loadAudioHistory();
  }

  void loadAudioHistory() {
    final audioBox = Boxes.getAudio();
    final audio = audioBox.get(Keys.keyAudioID);
    if (audio is UserAudioHistory && audio != null) {
      state = audio.audioList.toList();
    }
  }

  Future<void> addAudio(AudioModel audioModel) async {
    state = [...state, audioModel];
    final audioHistory = UserAudioHistory()..audioList = state;
    final audioBox = Boxes.getAudio();
    await audioBox.put(Keys.keyAudioID, audioHistory);
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
        final pickedFilePath = result.files.single.path ?? '';
        final fileName = result.files.single.name;

        // Get the app's temporary directory
        final tempDir = await getTemporaryDirectory();
        final targetPath = '${tempDir.path}/$fileName';

        // Move the file to the temporary directory
        final pickedFile = File(pickedFilePath);
        final movedFile = await pickedFile.copy(targetPath);

        final path = movedFile.path;
        final file = File(path);
        double fileSizeMB = file.lengthSync() / (1024 * 1024);

        if (fileSizeMB >= 25 && !isUserSubscribed) {
          StoreConfig.showSubscription(context);
          return;
        }

        ref.read(isAudioLoadingProvider.notifier).state = true;
        final languageCode = ref.watch(strAudioFileLanguageProvider);

        Responsemodel? responsemodel = await ApiService.speechToTextDG(
          path,
          languageCode,
          context,
        );

        ref.read(isAudioLoadingProvider.notifier).state = false;
        debugPrint((responsemodel?.paragraphs.transcript == "").toString());
        if (responsemodel?.paragraphs.transcript == "" ||
            responsemodel == null) {
          Utils.errorFeedbackDialog(context);
          return;
        }
        // responsemodel ??= Responsemodel(
        //     paragraphs: Paragraphs(
        //   transcript: Strings.strNoResultFound,
        // ));
        final user = ref.read(userProvider.notifier).state.getUser;

        //Add in database
        Utils.addUser(intAudio: (user.intAudio ?? 0) + 1);

        //Ask review
        if (user.intAudio == 0) {
          Future.delayed(const Duration(seconds: 2), () {
            // if (mounted) Utils.reviewDialog(context);
            Utils.openReviewDialog();
          });
        } else if (user.intAudio == 2 ||
            user.intAudio == 4 ||
            user.intAudio == 6) {
          if (mounted) Utils.reviewDialog(context);
        }
        String filename = basename(path);
        final audioModel = AudioModel(
          id: DateTime.now().millisecondsSinceEpoch,
          filename: filename,
          filePath: path,
          date: Utils.getCurrentDateAndTime(),
          responseModel: responsemodel,
        );

        await addAudio(audioModel);
        Utils.sendAnalyticsEvent(Keys.strAnlAudioDone);
      }
    } catch (e) {
      ref.read(isAudioLoadingProvider.notifier).state = false;
    }
  }
}
