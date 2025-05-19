import 'package:audioplayers/audioplayers.dart' as player;
import 'package:flutter/services.dart';

import 'package:transcribe/components/components.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/models/audiomodel.dart';

class AudioDetail extends StatefulWidget {
  final AudioModel audioModel;
  const AudioDetail({super.key, required this.audioModel});

  @override
  State<AudioDetail> createState() => _AudioDetailState();
}

class _AudioDetailState extends State<AudioDetail> {
  final player.AudioPlayer globalAudioPlayer =
      player.AudioPlayer(); // Global audio player
  final player.AudioPlayer paragraphAudioPlayer =
      player.AudioPlayer(); // Paragraph audio player

  bool isPlaying = false;
  bool isGlobalPlaying = false;
  bool showFullTranscription = false;

  Duration? globalCurrentPosition = Duration.zero;

  Map<int, bool> isParagraphPlaying = {}; // Track play state for each paragraph

  @override
  void initState() {
    super.initState();

    // Global audio player listeners
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

    // Paragraph audio player listeners
    paragraphAudioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isParagraphPlaying.clear(); // Stop all paragraph playback when complete
      });
    });

    Utils.sendAnalyticsEvent(Keys.sourceView);
  }

  @override
  void dispose() {
    globalAudioPlayer.dispose();
    paragraphAudioPlayer.dispose();
    super.dispose();
  }

  // Toggle global play/pause
  Future<void> toggleGlobalPlayPause() async {
    Utils.sendAnalyticsEvent('FullAudioPlayPauseTap');
    try {
      if (isGlobalPlaying) {
        // If global is playing, pause it
        await globalAudioPlayer.pause();
      } else {
        // If global is not playing, play it and pause any paragraph audio if it's playing
        final filePath = await Utils.getAudioPath(widget.audioModel.filePath);
        if (filePath != '') {
          player.DeviceFileSource source = player.DeviceFileSource(filePath);
          await globalAudioPlayer.play(source);
        } else {
          showToast('Error while playing audio');
        }

        // Pause paragraph audio if it's playing
        if (isParagraphPlaying.containsValue(true)) {
          for (int i = 0; i < isParagraphPlaying.length; i++) {
            if (isParagraphPlaying[i] ?? false) {
              await paragraphAudioPlayer.pause();
              setState(() {
                isParagraphPlaying[i] = false; // Update state
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

  // Toggle paragraph play/pause
  // Toggle paragraph play/pause
  Future<void> toggleParagraphPlayPause(
      int index, double start, double end) async {
    try {
      // Pause global audio if it's playing
      if (isGlobalPlaying) {
        await globalAudioPlayer.pause();
        setState(() {
          isGlobalPlaying = false;
        });
      }

      // Stop any currently playing paragraph
      for (int i = 0; i < isParagraphPlaying.length; i++) {
        if (i != index && (isParagraphPlaying[i] ?? false)) {
          await paragraphAudioPlayer.pause(); // Pause the previous paragraph
          setState(() {
            isParagraphPlaying[i] = false; // Update state
          });
        }
      }

      // Get the file path for the paragraph
      final filePath = await Utils.getAudioPath(widget.audioModel.filePath);
      if (filePath == '') {
        showToast('Error while playing paragraph');
        return;
      }

      // If the paragraph is already playing, pause it
      if (isParagraphPlaying[index] == true) {
        await paragraphAudioPlayer.pause();
      } else {
        // Start playing the paragraph from the specified start position
        player.DeviceFileSource source = player.DeviceFileSource(filePath);
        await paragraphAudioPlayer.play(source);

        // Ensure we seek to the correct position
        await paragraphAudioPlayer.seek(Duration(seconds: start.toInt()));
      }

      // Update the state for the current paragraph
      setState(() {
        isParagraphPlaying[index] = !(isParagraphPlaying[index] ?? false);
      });
    } catch (e) {
      debugPrint('Error playing paragraph: $e');
    }
  }

  Widget _buildTranscriptionTimeline() {
    final paragraphs = widget.audioModel.responseModel?.paragraphs.paragraphs;
    final transcript = widget.audioModel.responseModel?.paragraphs.transcript;

    // If paragraphs is null or empty, and transcript has a value, show the transcript
    if ((paragraphs == null || paragraphs.isEmpty) &&
        (transcript != null && transcript.isNotEmpty)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SelectableAutoLinkText(
            transcript,
            style: TextStyle(
              fontSize: Sizes.mediumFont,
              color: AppTheme.subtitleColor,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      );
    }

    // If paragraphs is not null or not empty, return the ListView.builder
    if (paragraphs != null && paragraphs.isNotEmpty) {
      return showFullTranscription
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SelectableAutoLinkText(
                  widget.audioModel.responseModel?.paragraphs.transcript ??
                      Strings.strNoResultFound,
                  style: TextStyle(
                      fontSize: Sizes.mediumFont,
                      color: AppTheme.subtitleColor,
                      fontWeight: FontWeight.w200),
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: paragraphs.length,
              itemBuilder: (context, paragraphIndex) {
                final paragraph = paragraphs[paragraphIndex];
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
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
                                  icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedCopy01,
                                    color: AppTheme.lightFontColor,
                                  ),
                                  onPressed: () {
                                    Utils.sendAnalyticsEvent('TimelineCopyTap');
                                    Clipboard.setData(ClipboardData(
                                      text: paragraph.sentences
                                          .map((sentence) => sentence.text)
                                          .join(' '),
                                    ));
                                    showToast('Copied');
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedShare01,
                                      color: AppTheme.lightFontColor,
                                    ),
                                    onPressed: () {
                                      Utils.sendAnalyticsEvent(
                                          'TimelineShareTap');
                                      Share.share(
                                        '${paragraph.sentences.map((sentence) => sentence.text).join(' ')} Appstore: $strAppstoreLink',
                                      );
                                    },
                                  ),
                                ),
                                FutureBuilder<String>(
                                  future: Utils.getAudioPath(
                                      widget.audioModel.filePath),
                                  builder: (context, snapshot) {
                                    return Visibility(
                                      visible: snapshot.data != '' &&
                                          snapshot.data != null,
                                      child: IconButton(
                                        onPressed: () {
                                          Utils.sendAnalyticsEvent(
                                              'TimelinePlayPauseTap');
                                          toggleParagraphPlayPause(
                                            paragraphIndex,
                                            paragraph.start,
                                            paragraph.end,
                                          );
                                        },
                                        icon: CircleAvatar(
                                          backgroundColor:
                                              AppTheme.primaryColor,
                                          radius: 15,
                                          child: Icon(
                                            isParagraphPlaying[
                                                        paragraphIndex] ==
                                                    true
                                                ? Icons.pause
                                                : Icons.play_arrow,
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
                          paragraph.sentences
                              .map((sentence) => sentence.text)
                              .join(' '),
                          style: TextStyle(
                            fontSize: Sizes.mediumFont,
                            color: AppTheme.subtitleColor,
                            fontWeight: FontWeight.w200,
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

    // If there is no transcript or paragraphs, return the 'No transcript available' message
    return const Center(child: Text(Strings.strNoResultFound));
  }

  String _formatDuration(double? seconds) {
    if (seconds == null) return "00:00";
    final duration = Duration(seconds: seconds.toInt());
    return "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.audioModel.filename),
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightFontColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildTranscriptionTimeline()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        widget.audioModel.responseModel?.paragraphs.paragraphs
                                    ?.isNotEmpty ??
                                false
                            ? IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedNote04,
                                  color: AppTheme.lightFontColor,
                                ),
                                onPressed: () {
                                  Utils.sendAnalyticsEvent(
                                      'FullTranscriptionTap');
                                  setState(() {
                                    showFullTranscription =
                                        !showFullTranscription;
                                  });
                                  //show Full transcription
                                },
                              )
                            : const SizedBox(),
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedCopy01,
                            color: AppTheme.lightFontColor,
                          ),
                          onPressed: () {
                            Utils.sendAnalyticsEvent('FullCopyTap');
                            Clipboard.setData(ClipboardData(
                              text: widget.audioModel.responseModel?.paragraphs
                                      .transcript ??
                                  Strings.strNoResultFound,
                            ));
                            showToast('Copied');
                          },
                        ),
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedShare01,
                            color: AppTheme.lightFontColor,
                          ),
                          onPressed: () {
                            Utils.sendAnalyticsEvent('FullShareTap');
                            Share.share(
                              '${widget.audioModel.responseModel?.paragraphs.transcript ?? Strings.strNoResultFound} } Appstore: $strAppstoreLink',
                            );
                          },
                        ),
                      ],
                    ),
                    FutureBuilder<String>(
                      future: Utils.getAudioPath(widget.audioModel.filePath),
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
                                  isGlobalPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
