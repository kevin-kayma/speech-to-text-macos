import 'dart:io';

import 'package:transcribe/components/components.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/models/models.dart';
import 'package:transcribe/pages/audiolist.dart';
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
    Utils.sendAnalyticsEvent(Keys.sourceView);
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

        if (initAlertData.intMaxAudio != null &&
            initAlertData.intMaxAudio!.isNotEmpty) {
          intMaxAudio =
              int.parse(initAlertData.intMaxAudio ?? '2'); // Parse to int
        }

        if (initAlertData.intMaxRecordAudio != null &&
            initAlertData.intMaxRecordAudio!.isNotEmpty) {
          intMaxRecordAudio =
              int.parse(initAlertData.intMaxRecordAudio ?? '2'); // Parse to int
        }

        if (initAlertData.deepKey != '' && initAlertData.deepKey != null) {
          deepLinkKey = initAlertData.deepKey ?? deepLinkKey;
        }

        if (initAlertData.isAlert == Keys.keyTrue && mounted) {
          if (initAlertData.isForcefullyUpdate == Keys.keyTrue &&
              version != initAlertData.appVersion) {
            Utils.initMessageDialog(context, initAlertData: initAlertData);
          } else if (initAlertData.msgAction == Keys.keyAppUpdate &&
              (version != initAlertData.appVersion &&
                  (userInfo?.strAlertID != initAlertData.alertID))) {
            Utils.initMessageDialog(context, initAlertData: initAlertData);
          } else if (initAlertData.msgAction != Keys.keyAppUpdate &&
              (userInfo?.strAlertID != initAlertData.alertID)) {
            Utils.initMessageDialog(context, initAlertData: initAlertData);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listAudio = ref.watch(audioListProvider);
    final isAudioLoading = ref.watch(isAudioLoadingProvider);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            listAudio.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listAudio.length > 2 ? 2 : listAudio.length,
                      itemBuilder: (context, index) {
                        final reversedList =
                            listAudio.reversed.toList(); // Reverse the list
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
                              fontSize: Sizes.mediumFont,
                              color: AppTheme.greyFontColor,
                              fontWeight: FontWeight.w100),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
            Expanded(
              flex: 0,
              child: Visibility(
                visible: listAudio.length > 2 && !isAudioLoading,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllAudioListScreen()),
                      );
                    },
                    child: Chip(
                      backgroundColor: AppTheme.cardBackgroundColor,
                      shape: const StadiumBorder(),
                      label: Text(
                        'View All',
                        style: TextStyle(
                            fontSize: Sizes.mediumFont,
                            color: AppTheme.lightFontColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: isAudioLoading
                    ? Column(
                        children: [
                          const Text(
                            'Transcribing... Please Wait',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 260,
                            child: Lottie.asset(
                              AssetsPath.loaderJson,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(Strings.strSelectLanguage,
                                  style: TextStyle(
                                      color: AppTheme.greyFontColor,
                                      fontSize: Sizes.smallFont,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2.0, style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                              ),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppTheme.greyBackgroundColor,
                                        width: 3.0),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppTheme.greyBackgroundColor,
                                        width: 3.0),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.greyBackgroundColor,
                                ),
                                dropdownColor: AppTheme.greyBackgroundColor,
                                menuMaxHeight:
                                    MediaQuery.of(context).size.height / 2,
                                value: listLanguages.entries
                                    .firstWhere(
                                      (entry) =>
                                          entry.value ==
                                          ref.watch(
                                              strAudioFileLanguageProvider),
                                      orElse: () =>
                                          const MapEntry('Auto Detect', ''),
                                    )
                                    .key,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    // Store language code in the provider
                                    ref
                                        .read(strAudioFileLanguageProvider
                                            .notifier)
                                        .state = listLanguages[newValue] ?? '';
                                  }
                                },
                                items: listLanguages.keys
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: Sizes.mediumFont,
                                        color: AppTheme.lightFontColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 12,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                  ),
                                  onPressed: () {
                                    currentSource = Source.audio;
                                    Utils.sendAnalyticsEvent(Keys.sourceView);
                                    ref
                                        .read(audioListProvider.notifier)
                                        .pickAndAddAudio(ref, context);
                                  },
                                  icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedFileAudio,
                                    color: AppTheme.darkFontColor,
                                  ),
                                  label: Text(
                                    Strings.strImportAudioFile.toUpperCase(),
                                    style: TextStyle(
                                        color: AppTheme.darkFontColor),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                  ),
                                  onPressed: () {
                                    currentSource = Source.record;
                                    Utils.sendAnalyticsEvent(Keys.sourceView);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RecordAudio(),
                                      ),
                                    ).then((_) {
                                      // This will refresh the audio list when you return to the home screen
                                      ref
                                          .read(audioListProvider.notifier)
                                          .loadAudioHistory();
                                    });
                                  },
                                  icon: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: HugeIcon(
                                      icon: HugeIcons.strokeRoundedMic01,
                                      color: AppTheme.darkFontColor,
                                    ),
                                  ),
                                  label: Text(
                                    Strings.strRecordAudio.toUpperCase(),
                                    style: TextStyle(
                                        color: AppTheme.darkFontColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
