// ignore_for_file: use_build_context_synchronously

import 'package:audioplayers/audioplayers.dart' as player;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:transcribe/components/components.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/controllers/chat_controller.dart';
import 'package:transcribe/controllers/home_controller.dart';
import 'package:transcribe/extension/context_extension.dart';
import 'package:transcribe/extension/padding_extension.dart';
import 'package:transcribe/models/audiomodel.dart';
import 'package:transcribe/models/paragraph.dart';
import 'package:transcribe/models/paragraphs.dart';
import 'package:transcribe/models/responsemodel.dart';
import 'package:transcribe/models/sentence.dart';
import 'package:transcribe/pages/chat_screen.dart';
import 'package:transcribe/pages/summary_page.dart';
import 'package:transcribe/providers/audio_provider.dart';

class ResultWidget extends ConsumerStatefulWidget {
  const ResultWidget({
    required this.responsemodel,
    required this.audioPath,
    super.key,
  });

  final Responsemodel responsemodel;
  final String audioPath;

  @override
  ConsumerState<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends ConsumerState<ResultWidget> {
  final player.AudioPlayer globalAudioPlayer = player.AudioPlayer();
  final player.AudioPlayer paragraphAudioPlayer = player.AudioPlayer();
  AudioModel audioModel = AudioModel(
    id: -1,
    filename: 'filename',
    filePath: 'filePath',
    date: 'date',
    responseModel: Responsemodel(
      paragraphs: Paragraphs(transcript: ''),
    ),
  );
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPlaying = false;
  bool isGlobalPlaying = false;
  bool showFullTranscription = false;

  Duration? globalCurrentPosition = Duration.zero;

  Map<int, bool> isParagraphPlaying = {};

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Durations.medium4);
      audioModel = AudioModel(
        id: tempAudioId,
        filename: '',
        filePath: widget.audioPath,
        date: Utils.getCurrentDateAndTime(),
        responseModel: widget.responsemodel,
      );
      setState(() {});
    });
    globalAudioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isGlobalPlaying = false;
      });
    });

    globalAudioPlayer.onPositionChanged.listen((position) {
      setState(() {
        globalCurrentPosition = position;
      });
    });

    paragraphAudioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isParagraphPlaying.clear(); // Stop all paragraph playback when complete
      });
    });
  }

  @override
  void dispose() {
    globalAudioPlayer.dispose();
    paragraphAudioPlayer.dispose();
    super.dispose();
  }

  void editSummary(String summaryText, Paragraph paragraph, int index) {
    TextEditingController controller = TextEditingController(text: summaryText);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: context.width * 0.6,
          height: context.height * 0.8,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.white.withAlpha(40),
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Transcription',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ).paddingOnly(left: 10),
                const SizedBox(height: 15),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    maxLines: 100,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    style: const TextStyle(color: AppTheme.lightFontColor),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Enter the valid value';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Edit your summary here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.cardBackgroundColor,
                      contentPadding: const EdgeInsets.all(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          List<Paragraph> paragraphList = audioModel.responseModel?.paragraphs.paragraphs ?? [];
                          paragraphList[index] = Paragraph(
                            sentences: [Sentence(text: controller.text, confidence: 0)],
                            numWords: controller.text.split(' ').length,
                            start: paragraphList[index].start,
                            end: paragraphList[index].end,
                          );
                          final newModel = audioModel.copyWith(
                            responseModel: Responsemodel(
                              paragraphs: Paragraphs(
                                transcript: audioModel.responseModel?.paragraphs.transcript ?? '',
                                paragraphs: paragraphList,
                              ),
                            ),
                          );
                          ref.read(audioListProvider.notifier).deleteAudio(audioModel.id);
                          ref.read(audioListProvider.notifier).addAudio(newModel);
                          ref.read(audioListProvider.notifier).loadAudioHistory();
                          setState(() {
                            audioModel = newModel;
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> toggleGlobalPlayPause() async {
    Utils.sendAnalyticsEvent(AnalyticsEvents.playFull);
    try {
      if (isGlobalPlaying) {
        await globalAudioPlayer.pause();
      } else {
        final filePath = await Utils.getFilepath(audioModel.filePath);
        if (filePath != '') {
          player.DeviceFileSource source = player.DeviceFileSource(filePath);
          await globalAudioPlayer.play(source);
        } else {
          showToast('Error while playing audio');
        }

        if (isParagraphPlaying.containsValue(true)) {
          for (int i = 0; i < isParagraphPlaying.length; i++) {
            if (isParagraphPlaying[i] ?? false) {
              await paragraphAudioPlayer.pause();
              setState(() {
                isParagraphPlaying[i] = false;
              });
            }
          }
        }
      }

      setState(() {
        isGlobalPlaying = !isGlobalPlaying;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toggleParagraphPlayPause(int index, double start, double end) async {
    try {
      if (isGlobalPlaying) {
        await globalAudioPlayer.pause();
        setState(() {
          isGlobalPlaying = false;
        });
      }

      for (int i = 0; i < isParagraphPlaying.length; i++) {
        if (i != index && (isParagraphPlaying[i] ?? false)) {
          await paragraphAudioPlayer.pause();
          setState(() {
            isParagraphPlaying[i] = false;
          });
        }
      }

      final filePath = await Utils.getFilepath(audioModel.filePath);
      if (filePath == '') {
        showToast('Error while playing paragraph');
        return;
      }

      if (isParagraphPlaying[index] == true) {
        await paragraphAudioPlayer.pause();
      } else {
        player.DeviceFileSource source = player.DeviceFileSource(filePath);
        await paragraphAudioPlayer.play(source);

        await paragraphAudioPlayer.seek(Duration(seconds: start.toInt()));
      }

      setState(() {
        isParagraphPlaying[index] = !(isParagraphPlaying[index] ?? false);
      });
    } catch (e) {
      debugPrint('Error playing paragraph: $e');
    }
  }

  Widget _buildTranscriptionTimeline() {
    final paragraphs = audioModel.responseModel?.paragraphs.paragraphs;
    final transcript = audioModel.responseModel?.paragraphs.transcript;

    if ((paragraphs == null || paragraphs.isEmpty) && (transcript != null && transcript.isNotEmpty)) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.primaryColor.withAlpha(40),
              width: 0.5,
            ),
          ),
          child: SelectableAutoLinkText(
            transcript,
            style: TextStyle(fontSize: Sizes.largeFont, color: AppTheme.subtitleColor),
          ),
        ),
      );
    }

    if (paragraphs != null && paragraphs.isNotEmpty) {
      return showFullTranscription
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.primaryColor.withAlpha(40),
                    width: 0.5,
                  ),
                ),
                child: SelectableAutoLinkText(
                  audioModel.responseModel?.paragraphs.transcript ?? Strings.strNoResultFound,
                  style: TextStyle(fontSize: 17.sp, color: AppTheme.subtitleColor),
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: paragraphs.length,
              itemBuilder: (context, paragraphIndex) {
                final paragraph = paragraphs[paragraphIndex];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_formatDuration(paragraph.start)} -> ${_formatDuration(paragraph.end)}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedEdit02,
                                    color: AppTheme.lightFontColor,
                                  ),
                                  onPressed: () {
                                    Utils.sendAnalyticsEvent(AnalyticsEvents.editParagraph);
                                    editSummary(
                                      paragraph.sentences.map((sentence) => sentence.text).join(' '),
                                      paragraph,
                                      paragraphIndex,
                                    );
                                  },
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedCopy01,
                                    color: AppTheme.lightFontColor,
                                  ),
                                  onPressed: () {
                                    Utils.sendAnalyticsEvent(AnalyticsEvents.copyPara);
                                    Clipboard.setData(ClipboardData(
                                      text: paragraph.sentences.map((sentence) => sentence.text).join(' '),
                                    ));
                                    showToast('Copied', AppTheme.darkFontColor);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: const HugeIcon(
                                      icon: HugeIcons.strokeRoundedShare01,
                                      color: AppTheme.lightFontColor,
                                    ),
                                    onPressed: () {
                                      Utils.sendAnalyticsEvent(AnalyticsEvents.sharePara);
                                      Share.share(
                                        '${paragraph.sentences.map((sentence) => sentence.text).join(' ')} Appstore: $strAppstoreLink',
                                      );
                                    },
                                  ),
                                ),
                                FutureBuilder<String>(
                                  future: Utils.getFilepath(audioModel.filePath),
                                  builder: (context, snapshot) {
                                    return Visibility(
                                      visible: snapshot.data != '' && snapshot.data != null,
                                      child: IconButton(
                                        onPressed: () {
                                          Utils.sendAnalyticsEvent(AnalyticsEvents.playPara);
                                          toggleParagraphPlayPause(
                                            paragraphIndex,
                                            paragraph.start,
                                            paragraph.end,
                                          );
                                        },
                                        icon: CircleAvatar(
                                          backgroundColor: AppTheme.primaryColor,
                                          radius: 15,
                                          child: Icon(
                                            isParagraphPlaying[paragraphIndex] == true ? Icons.pause : Icons.play_arrow,
                                            color: AppTheme.darkFontColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          paragraph.sentences.map((sentence) => sentence.text).join(' '),
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: AppTheme.subtitleColor,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                );
              },
            );
    }

    return const Center(child: Text(Strings.strNoResultFound));
  }

  String _formatDuration(double? seconds) {
    if (seconds == null) return "00:00";
    final duration = Duration(seconds: seconds.toInt());
    return "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final homeWatch = ref.watch(homeController);
    return Stack(
      children: [
        Column(
          children: [
            Expanded(child: _buildTranscriptionTimeline()),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Utils.sendAnalyticsEvent(AnalyticsEvents.summaryTap);
                      if (audioModel.summary != null && (audioModel.summary?.isNotEmpty ?? false)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SummaryScreen(summaryText: audioModel.summary!),
                          ),
                        );
                      } else {
                        if (Utils.isCanAccess(CanAccess.summary)) {
                          final summary = await homeWatch.generateSummary(
                            context,
                            audioModel.responseModel?.paragraphs.transcript ?? '',
                          );
                          if (summary.isNotEmpty) {
                            final newModel = audioModel.copyWith(summary: summary);
                            ref.read(audioListProvider.notifier).deleteAudio(newModel.id);
                            ref.read(audioListProvider.notifier).addAudio(newModel);
                            setState(() {
                              audioModel = newModel;
                            });
                            await Future.delayed(Durations.medium1);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SummaryScreen(
                                  summaryText: summary,
                                  isFirstTime: true,
                                ),
                              ),
                            );
                          } else {
                            showToast('Some error occured while generating summary');
                          }
                        } else {
                          StoreConfig.showSubscription(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedNote,
                      color: AppTheme.darkFontColor,
                    ),
                    label: const Text(
                      'Summary',
                      style: TextStyle(color: AppTheme.darkFontColor),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Utils.sendAnalyticsEvent(AnalyticsEvents.chatBotTap);
                      final chatbotState = ref.read(chatbotProvider);
                      chatbotState.chatHistory.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            audioId: audioModel.id,
                            transcript: audioModel.responseModel?.paragraphs.transcript ?? '',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedAiChat02,
                      color: AppTheme.darkFontColor,
                    ),
                    label: const Text(
                      'Ask Question',
                      style: TextStyle(color: AppTheme.darkFontColor),
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: context.width * 0.08),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                audioModel.responseModel?.paragraphs.paragraphs?.isNotEmpty ?? false
                    ? Tooltip(
                        message: 'Toggle Transcription',
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            showFullTranscription
                                ? LucideIcons.fileText400
                                : HugeIcons.strokeRoundedLeftToRightListDash,
                            color: AppTheme.lightFontColor,
                          ),
                          onPressed: () {
                            Utils.sendAnalyticsEvent(AnalyticsEvents.toggleTranscription);
                            setState(
                              () {
                                showFullTranscription = !showFullTranscription;
                              },
                            );
                            //show Full transcription
                          },
                        ),
                      )
                    : const SizedBox(),
                Tooltip(
                  message: 'Copy',
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedCopy01,
                      color: AppTheme.lightFontColor,
                    ),
                    onPressed: () {
                      Utils.sendAnalyticsEvent(AnalyticsEvents.copyFull);
                      Clipboard.setData(ClipboardData(
                        text: audioModel.responseModel?.paragraphs.transcript ?? Strings.strNoResultFound,
                      ));
                      showToast('Copied', AppTheme.darkFontColor);
                    },
                  ),
                ),
                Tooltip(
                  message: 'Share',
                  triggerMode: TooltipTriggerMode.longPress,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedShare01,
                      color: AppTheme.lightFontColor,
                    ),
                    onPressed: () {
                      Utils.sendAnalyticsEvent(AnalyticsEvents.shareFull);
                      Share.share(
                        '${audioModel.responseModel?.paragraphs.transcript ?? Strings.strNoResultFound} } Appstore: $strAppstoreLink',
                      );
                    },
                  ),
                ),
                const Spacer(),
                FutureBuilder<String>(
                  future: Utils.getFilepath(audioModel.filePath),
                  builder: (context, snapshot) {
                    return Visibility(
                      visible: snapshot.data != '' && snapshot.data != null,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          radius: Sizes.radius,
                          child: IconButton(
                            onPressed: toggleGlobalPlayPause,
                            icon: Icon(
                              isGlobalPlaying ? Icons.pause : Icons.play_arrow,
                              color: AppTheme.darkFontColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ).paddingSymmetric(horizontal: 12),
        homeWatch.isSummaryGenerating
            ? Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withAlpha(160)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                        strokeWidth: 6.0,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Generating Summary...',
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Please wait while we generate the summary for you.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ).paddingSymmetric(horizontal: 40),
                    ],
                  ),
                ),
              )
            : const Offstage(),
        audioModel.id == -1
            ? Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                        strokeWidth: 6.0,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Loading Transcription',
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              )
            : const Offstage(),
      ],
    );
  }
}
