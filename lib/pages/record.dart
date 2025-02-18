import 'package:flutter/services.dart';
import 'package:transcribe/components/components.dart';

import 'package:transcribe/config/config.dart';
import 'package:transcribe/apis/network.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:transcribe/models/audiomodel.dart';
import 'package:transcribe/models/boxes.dart';
import 'package:transcribe/models/listaudiomodel.dart';
import 'package:transcribe/models/paragraphs.dart';
import 'package:transcribe/models/responsemodel.dart';

import 'dart:io';

import 'package:transcribe/providers/audio_provider.dart';
import 'package:transcribe/providers/user_provider.dart';

class RecordAudio extends ConsumerStatefulWidget {
  const RecordAudio({super.key});

  @override
  ConsumerState<RecordAudio> createState() => _RecordAudioState();
}

class _RecordAudioState extends ConsumerState<RecordAudio> {
  String strSpeechResult = "";
  String filename = "recording";
  String filePath = "";
  Responsemodel? responsemodel;

  final recorder = AudioRecorder();
  bool isRecording = false;
  bool isPause = true;
  bool isResume = false;

  static TextEditingController textEditingController = TextEditingController();
  static FocusNode focusNode = FocusNode();

  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isVoiceRecordLoadingProvider.notifier).state = false;
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false; // Toggle the state
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    audioPlayer.dispose();
    recorder.dispose();
  }

  Future startRecord(BuildContext context) async {
    bool isConnection = await Utils.checkInternet();
    if (isConnection) {
      try {
        await Utils.refreshSubscription();
        if (Utils.isCanAccess(CanAccess.recordaudio)) {
          // Check and request microphone permissions
          if (await recorder.hasPermission()) {
            final exPath = await Utils.getDirectory();
            debugPrint(exPath + 'exPath');
            // Start the recording
            await recorder.start(
              const RecordConfig(
                encoder: AudioEncoder.pcm16bits,
                sampleRate: 16000,
                numChannels: 1,
              ),
              path: exPath,
            );
// Add a small delay to ensure the recorder has started
            await Future.delayed(Duration(milliseconds: 200));

            isRecording = await recorder.isRecording();
            isPause = true;
            isResume = false;

            debugPrint('Recording started: $isRecording');
          } else {
            showToast(Strings.strGrantAudioPermission);
          }

          setState(() {});
        } else {
          StoreConfig.showSubscription(context);
        }
      } catch (e) {
        debugPrint('---' + e.toString() + 'error');
      }
    } else {
      // ignore: use_build_context_synchronously
      Utils.noNetworkDialog(context, onRetry: (() async {
        Navigator.of(context).pop();
        await startRecord(context);
      }));
    }
  }

  Future stopRecorder() async {
    filePath = await recorder.stop() ?? '';
    isRecording = await recorder.isRecording();

    setState(() {});
    final languageCode = ref.watch(strAudioFileLanguageProvider);

    debugPrint(filePath);
    ref.read(isVoiceRecordLoadingProvider.notifier).state = true;

    if (!mounted) return;
    responsemodel =
        await ApiService.speechToTextDG(filePath, languageCode, context);
    ref.read(isVoiceRecordLoadingProvider.notifier).state = false;

    //Add in databse
    final user = ref.read(userProvider.notifier).state.getUser;
    Utils.addUser(intRecordAudio: (user.intRecordAudio ?? 0) + 1);

    //Ask review
    if (user.intRecordAudio == 0) {
      Utils.openReviewDialog();
      // Future.delayed(const Duration(seconds: 2), () {
      //   Utils.reviewDialog(context);
      // });
    }

    if (user.intRecordAudio == 1) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Utils.reviewDialog(context);
      });
    }
    if (responsemodel == null) {
      responsemodel = Responsemodel(
        paragraphs: Paragraphs(
          transcript: Strings.strNoResultFound,
        ),
      );
    } else {
      strSpeechResult =
          responsemodel?.paragraphs.transcript ?? Strings.strNoResultFound;
    }

    setState(() {});
  }

  Future<void> togglePlayPause() async {
    debugPrint('File path: $filePath');

    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        // await audioPlayer.play(AssetSource('/audio/harvard.wav'));
        final file = File(filePath);
        if (await file.exists()) {
          debugPrint('File exists: ${file.path}');

          DeviceFileSource source = DeviceFileSource(filePath);
          await audioPlayer.play(source);
        } else {
          debugPrint('File does not exist: ${file.path}');
        }
      }
      setState(() {
        isPlaying = !isPlaying;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  saveRecording() async {
    //Save Record In History
    final audioBox = Boxes.getAudio();
    final audio = audioBox.get(Keys.keyAudioID);
    if (audio is AudioModel && audio != null) {
      audioID = audio.audioList.last.id;
    }
    audioID++;
    final audioModel = AudioModel(
      id: audioID,
      filename: filename,
      filePath: filePath,
      date: Utils.getCurrentDateAndTime(),
      responseModel: responsemodel,
    );
    List<AudioModel> listAudio = audio?.audioList.toList() ?? [];
    listAudio.add(audioModel);

    final audioHistory = UserAudioHistory()..audioList = listAudio;
    await audioBox.put(Keys.keyAudioID, audioHistory);
  }

  @override
  Widget build(BuildContext context) {
    bool isAudioLoading = ref.watch(isVoiceRecordLoadingProvider);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightFontColor,
        title: Text(Strings.strRecordAudio),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            Expanded(
              child: strSpeechResult != ''
                  ? SelectableAutoLinkText(
                      strSpeechResult,
                      style: TextStyle(
                          color: AppTheme.lightFontColor,
                          // fontWeight: FontWeight.w500,
                          fontSize: Sizes.largeFont),
                      // items: [
                      //   CustomSelectableTextItem(
                      //       controlType: SelectionControlType.copy),
                      //   CustomSelectableTextItem(
                      //       controlType: SelectionControlType.selectAll),
                      //   CustomSelectableTextItem(
                      //       label: Strings.strShare,
                      //       controlType: SelectionControlType.other,
                      //       onPressed: (text) {
                      //         Share.share(text);
                      //       }),
                      // ],
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          Strings.strNoRecordAudio,
                          style: TextStyle(
                            fontSize: Sizes.mediumFont,
                            color: AppTheme.greyFontColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
            isRecording && isPause
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Lottie.asset(
                      AssetsPath.recording,
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: filePath.isNotEmpty &&
                      !isRecording &&
                      strSpeechResult != '',
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      radius: Sizes.radius,
                      child: IconButton(
                        onPressed: togglePlayPause,
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppTheme.darkFontColor,
                        ),
                      ),
                    ),
                  ),
                ),
                isRecording
                    ? CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        radius: Sizes.radius,
                        child: IconButton(
                          onPressed: () async {
                            stopRecorder();
                            setState(() {});
                          },
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedSquare,
                            color: AppTheme.darkFontColor,
                          ),
                        ),
                      )
                    : isAudioLoading
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Visibility(
                            visible: strSpeechResult == '',
                            child: CircleAvatar(
                              backgroundColor: AppTheme.primaryColor,
                              radius: Sizes.radius,
                              child: IconButton(
                                onPressed: () async {
                                  await startRecord(context);
                                },
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedMic01,
                                  color: AppTheme.darkFontColor,
                                ),
                              ),
                            ),
                          ),
                SizedBox(
                  width: isRecording ? 12 : 0,
                ),
                isRecording
                    ? isPause
                        ? CircleAvatar(
                            backgroundColor: AppTheme.primaryColor,
                            radius: Sizes.radius,
                            child: IconButton(
                              onPressed: () {
                                isPause = false;
                                isResume = true;

                                recorder.pause().then((_) {
                                  // Use then() to handle the result
                                  setState(() {});
                                });
                              },
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedPause,
                                color: AppTheme.darkFontColor,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: AppTheme.primaryColor,
                            radius: Sizes.radius,
                            child: IconButton(
                              onPressed: () {
                                isPause = true;
                                isResume = false;

                                recorder.resume().then((_) {
                                  // Use then() to handle the result
                                  setState(() {});
                                });
                              },
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedPlay,
                                color: AppTheme.darkFontColor,
                              ),
                            ),
                          )
                    : SizedBox(),
                SizedBox(
                  width: strSpeechResult != '' || isRecording ? 12 : 0,
                ),
                Visibility(
                  visible: strSpeechResult != '' && !isRecording,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        radius: Sizes.radius,
                        child: IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: strSpeechResult));
                            showToast('Copied');
                          },
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedCopy01,
                            color: AppTheme.darkFontColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        radius: Sizes.radius,
                        child: IconButton(
                          onPressed: () {
                            onSaveRecord(context, ref);
                          },
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedDownload01,
                            color: AppTheme.darkFontColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void onSaveRecord(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      isDismissible: true,
      enableDrag: true,
      context: context,
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Recording Title',
                    style: TextStyle(
                        fontSize: Sizes.mediumFont,
                        color: AppTheme.lightFontColor,
                        fontWeight: FontWeight.bold),
                  ),
                  spacer(),
                  CloseButton(
                    color: AppTheme.darkFontColor,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              spacer(),
              TextField(
                focusNode: focusNode,
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppTheme.greyBackgroundColor, width: 3.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppTheme.greyBackgroundColor, width: 3.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Enter Title',
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  fillColor: AppTheme.textFieldBackgroundColor,
                  filled: true,
                  focusColor: AppTheme.greyBackgroundColor,
                ),
                style: TextStyle(
                  color: AppTheme
                      .lightFontColor, // Change to your desired text color
                ),
              ),
              spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (textEditingController.text != '') {
                    filename = textEditingController.text;
                    textEditingController.text = '';
                    await saveRecording();

                    showToast("Saved In History", AppTheme.primaryColor,
                        ToastGravity.CENTER);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else {
                    showToast('Please enter recording title', Colors.red,
                        ToastGravity.CENTER);
                  }
                },
                child: Text(
                  Strings.strSave,
                  style: TextStyle(color: AppTheme.darkFontColor),
                ),
              ),
              spacer()
            ],
          ),
        );
      },
    );
  }
}
