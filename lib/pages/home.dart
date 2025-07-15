import 'package:transcribe/components/components.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/controllers/home_controller.dart';
import 'package:transcribe/extension/context_extension.dart';
import 'package:transcribe/extension/padding_extension.dart';
import 'package:transcribe/models/models.dart';
import 'package:transcribe/pages/pages.dart';
import 'package:transcribe/providers/providers.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _AudioListState();
}

class _AudioListState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();

    currentSource = Source.home;
    Utils.sendAnalyticsEvent(AnalyticsEvents.sourceView);
    //Do something once widget tree built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = Boxes.getUser();
      final userInfo = user.get(Keys.keyUserID);

      //Init Alert Dialog
      try {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        // ref.read(strCurrentVersionProvider.notifier).state = version;
        debugPrint(version);

        if (initAlertData.intMaxAudio != null && initAlertData.intMaxAudio!.isNotEmpty) {
          intMaxAudio = int.parse(initAlertData.intMaxAudio ?? '2'); // Parse to int
        }

        if (initAlertData.intMaxRecordAudio != null && initAlertData.intMaxRecordAudio!.isNotEmpty) {
          intMaxRecordAudio = int.parse(initAlertData.intMaxRecordAudio ?? '2'); // Parse to int
        }

        if (initAlertData.deepKey != '' && initAlertData.deepKey != null) {
          deepLinkKey = initAlertData.deepKey ?? deepLinkKey;
        }

        if (initAlertData.isAlert == Keys.keyTrue && mounted) {
          if (initAlertData.isForcefullyUpdate == Keys.keyTrue && version != initAlertData.appVersion) {
            Utils.initMessageDialog(context, initAlertData: initAlertData);
          } else if (initAlertData.msgAction == Keys.keyAppUpdate &&
              (version != initAlertData.appVersion && (userInfo?.strAlertID != initAlertData.alertID))) {
            Utils.initMessageDialog(context, initAlertData: initAlertData);
          } else if (initAlertData.msgAction != Keys.keyAppUpdate && (userInfo?.strAlertID != initAlertData.alertID)) {
            Utils.initMessageDialog(context, initAlertData: initAlertData);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  final _cardGradient = LinearGradient(
    colors: [
      const Color(0xFFB983FF).withAlpha(70),
      const Color(0xFF8854D0).withAlpha(50),
      const Color(0xFF8854D0).withAlpha(30),
    ],
    stops: const [0.1, 0.4, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Widget _buildTranscribeCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: SizedBox(
        height: context.height * 0.4,
        // width: context.width,
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                gradient: _cardGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: icon,
                    color: AppTheme.lightFontColor,
                    size: 46,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightFontColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppTheme.lightFontColor.withAlpha(180),
                    ),
                  ).paddingSymmetric(horizontal: 20),
                ],
              ),
            ),
          ),
        ),
      ).paddingSymmetric(horizontal: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listAudio = ref.watch(audioListProvider);
    final isAudioLoading = ref.watch(isAudioLoadingProvider);
    final homeWatch = ref.watch(homeController);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightFontColor,
        title: const Text(strAppName),
        // leading: FutureBuilder(
        //   builder: (ctx, snapshot) {
        //     return snapshot.data ?? const SizedBox();
        //   },
        //   future: giftBox(context),
        // ).paddingSymmetric(horizontal: 6),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (homeWatch.selectedTile == Tile.history) ...{
                  listAudio.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listAudio.length,
                            itemBuilder: (context, index) {
                              final reversedList = listAudio.reversed.toList();
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: audioCard(context, reversedList[index]),
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                Strings.strNoAudioMsg,
                                style: TextStyle(
                                  fontSize: Sizes.largeFont,
                                  color: AppTheme.greyFontColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                } else ...{
                  Row(
                    children: [
                      _buildTranscribeCard(
                        onTap: () {
                          currentSource = Source.record;
                          Utils.sendAnalyticsEvent(AnalyticsEvents.recordAudioTap);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RecordAudio(),
                            ),
                          );
                        },
                        icon: HugeIcons.strokeRoundedMic01,
                        title: 'Record Audio',
                        subtitle: 'Tap to start a new voice recording',
                      ),
                      const SizedBox(height: 10),
                      _buildTranscribeCard(
                        onTap: () {
                          currentSource = Source.file;
                          Utils.sendAnalyticsEvent(AnalyticsEvents.importFileTap);
                          ref.read(audioListProvider.notifier).pickAndAddAudio(ref, context);
                        },
                        icon: HugeIcons.strokeRoundedFile01,
                        title: 'From Files',
                        subtitle: 'Import existing audio for transcription',
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  const Row(
                    children: [
                      Text(
                        Strings.strSelectLanguage,
                        style: TextStyle(
                          color: AppTheme.lightFontColor,
                        ),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 24),
                  Container(
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.greyBackgroundColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withAlpha(140),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withAlpha(140),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withAlpha(140),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withAlpha(140),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withAlpha(140),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withAlpha(140),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                      dropdownColor: AppTheme.greyBackgroundColor,
                      autofocus: true,
                      style: const TextStyle(),
                      menuMaxHeight: MediaQuery.of(context).size.height / 2,
                      value: listLanguages.entries
                          .firstWhere(
                            (entry) => entry.value == ref.watch(strAudioFileLanguageProvider),
                            orElse: () => const MapEntry('Auto Detect', ''),
                          )
                          .key,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          ref.read(strAudioFileLanguageProvider.notifier).state = listLanguages[newValue] ?? '';
                          Utils.sendAnalyticsEvent(AnalyticsEvents.selectLanguage(
                              listLanguages[newValue] == '' ? 'AD' : listLanguages[newValue] ?? 'AD'));
                          final user = ref.read(userProvider.notifier).state.getUser;
                          if (user.intChatReview != 1) {
                            Utils.reviewDialog(context);
                          }
                        }
                      },
                      items: listLanguages.keys.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: Sizes.mediumFont),
                          ),
                        );
                      }).toList(),
                    ),
                  ).paddingSymmetric(horizontal: 20, vertical: 8),
                },
                const SizedBox(height: 20)
                // Row(
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           homeWatch.updateSelectedTile(Tile.record);
                //         },
                //         child: Container(
                //           height: 54,
                //           decoration: BoxDecoration(
                //             color:
                //                 homeWatch.selectedTile == Tile.record ? Colors.white.withAlpha(15) : Colors.transparent,
                //             borderRadius: BorderRadius.circular(14),
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Icon(
                //                 HugeIcons.strokeRoundedMic01,
                //                 color: homeWatch.selectedTile == Tile.record
                //                     ? AppTheme.primaryColor
                //                     : Colors.white.withAlpha(200),
                //               ),
                //               const SizedBox(
                //                 width: 10,
                //               ),
                //               Text(
                //                 'Create',
                //                 style: TextStyle(
                //                   fontSize: 16.sp,
                //                   fontWeight: FontWeight.w500,
                //                   color: homeWatch.selectedTile == Tile.record
                //                       ? AppTheme.primaryColor
                //                       : Colors.white.withAlpha(200),
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () async {
                //           ref.read(audioListProvider.notifier).loadAudioHistory();
                //           homeWatch.updateSelectedTile(Tile.history);
                //         },
                //         child: Container(
                //           height: 54,
                //           decoration: BoxDecoration(
                //             color: homeWatch.selectedTile == Tile.history
                //                 ? Colors.white.withAlpha(15)
                //                 : Colors.transparent,
                //             borderRadius: BorderRadius.circular(14),
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Icon(
                //                 HugeIcons.strokeRoundedNote01,
                //                 color: homeWatch.selectedTile == Tile.history
                //                     ? AppTheme.primaryColor
                //                     : Colors.white.withAlpha(200),
                //               ),
                //               const SizedBox(
                //                 width: 10,
                //               ),
                //               Text(
                //                 'History',
                //                 style: TextStyle(
                //                   fontSize: 16.sp,
                //                   fontWeight: FontWeight.w500,
                //                   color: homeWatch.selectedTile == Tile.history
                //                       ? AppTheme.primaryColor
                //                       : Colors.white.withAlpha(200),
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ).paddingSymmetric(horizontal: 20, vertical: 10),
              ],
            ),
            Positioned.fill(
              child: isAudioLoading
                  ? Container(
                      width: context.width,
                      height: context.height,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(180),
                      ),
                      child: Center(
                        child: SizedBox(
                          height: context.height * 0.38,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Lottie.asset(
                                      frameRate: const FrameRate(40),
                                      AssetsPath.loaderJson,
                                    ),
                                  ),
                                  SizedBox(
                                    height: context.height * 0.1,
                                  )
                                ],
                              ),
                              Positioned(
                                bottom: context.height * 0.1,
                                right: 0,
                                left: 0,
                                child: Text(
                                  'Transcribing... Please Wait',
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.lightFontColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Offstage(),
            )
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }
}
