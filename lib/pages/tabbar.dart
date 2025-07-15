import 'package:flutter/material.dart';
import 'package:transcribe/components/components.dart';
import 'package:transcribe/controllers/home_controller.dart';
import 'package:transcribe/extension/padding_extension.dart';
import 'package:transcribe/pages/pages.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/providers/audio_provider.dart';

class Tabbar extends ConsumerStatefulWidget {
  const Tabbar({
    Key? key,
    this.index = 0,
  }) : super(key: key);

  final int index;

  @override
  ConsumerState<Tabbar> createState() => TabbarState();
}

class TabbarState extends ConsumerState<Tabbar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  Widget buildSidebarTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool selected,
  }) {
    return ListTile(
      leading: HugeIcon(icon: icon, color: AppTheme.lightFontColor),
      title: Text(title),
      // selectedTileColor: AppTheme.primaryColor.withAlpha(100),
      selectedColor: AppTheme.lightFontColor,
      iconColor: AppTheme.lightFontColor,
      textColor: AppTheme.lightFontColor,
      onTap: onTap,
      selected: selected,
    );
  }

  Widget buildNetworkDependentTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Future<void> Function() onAction,
  }) {
    return ListTile(
      trailing: HugeIcon(icon: icon, color: AppTheme.lightFontColor),
      title: Text(title),
      selectedTileColor: AppTheme.primaryColor.withAlpha(100),
      selectedColor: AppTheme.lightFontColor,
      textColor: AppTheme.lightFontColor,
      iconColor: AppTheme.lightFontColor,
      onTap: () async {
        bool isConnection = await Utils.checkInternet();
        if (isConnection) {
          await onAction();
        } else {
          Utils.noNetworkDialog(
            context,
            onRetry: () => Navigator.of(context).pop(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeWatch = ref.watch(homeController);
    return LayoutBuilder(
      builder: (context, constraints) {
        return MacosWindow(
          sidebar: Sidebar(
            minWidth: 260,
            maxWidth: 260,
            topOffset: 0.0,
            builder: (context, scrollController) {
              return Material(
                color: AppTheme.sidebarBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.sp),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(!isUserSubscribed ? 12.0 : 0),
                              child: FutureBuilder(
                                future: subscriptionCard(context),
                                builder: (ctx, snapshot) => snapshot.data ?? const SizedBox(),
                              ),
                            ),
                            !isUserSubscribed
                                ? const Divider(
                                    color: AppTheme.greyFontColor,
                                  )
                                : const SizedBox(),
                            // buildSidebarTile(
                            //   icon: HugeIcons.strokeRoundedVoice,
                            //   title: strAppName,
                            //   onTap: () => setState(() => currentIndex = 0),
                            //   selected: currentIndex == 0,
                            // ),
                            GestureDetector(
                              onTap: () {
                                homeWatch.updateSelectedTile(Tile.record);
                              },
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  color: homeWatch.selectedTile == Tile.record
                                      ? Colors.white.withAlpha(15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      HugeIcons.strokeRoundedMic01,
                                      color: homeWatch.selectedTile == Tile.record
                                          ? AppTheme.primaryColor
                                          : Colors.white.withAlpha(200),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Transcribe',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: homeWatch.selectedTile == Tile.record
                                            ? AppTheme.primaryColor
                                            : Colors.white.withAlpha(200),
                                      ),
                                    )
                                  ],
                                ).paddingSymmetric(horizontal: 10),
                              ),
                            ).paddingSymmetric(horizontal: 10),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                ref.read(audioListProvider.notifier).loadAudioHistory();
                                homeWatch.updateSelectedTile(Tile.history);
                              },
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  color: homeWatch.selectedTile == Tile.history
                                      ? Colors.white.withAlpha(15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      HugeIcons.strokeRoundedNote01,
                                      color: homeWatch.selectedTile == Tile.history
                                          ? AppTheme.primaryColor
                                          : Colors.white.withAlpha(200),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'History',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: homeWatch.selectedTile == Tile.history
                                            ? AppTheme.primaryColor
                                            : Colors.white.withAlpha(200),
                                      ),
                                    )
                                  ],
                                ).paddingSymmetric(horizontal: 10),
                              ),
                            ).paddingSymmetric(horizontal: 10),

                            const Divider(
                              color: AppTheme.greyFontColor,
                            ),
                            buildNetworkDependentTile(
                              context: context,
                              icon: HugeIcons.strokeRoundedMagicWand02,
                              title: Strings.strRateApp,
                              onAction: () async {
                                Utils.sendAnalyticsEvent(AnalyticsEvents.settingRateApp);
                                bool isConnection = await Utils.checkInternet();
                                if (isConnection) {
                                  Utils.openStoreReview();
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Utils.noNetworkDialog(context, onRetry: (() {
                                    Navigator.of(context).pop();
                                  }));
                                }
                              },
                            ),
                            buildNetworkDependentTile(
                              context: context,
                              icon: HugeIcons.strokeRoundedShare05,
                              title: Strings.strShareApp,
                              onAction: () async {
                                Utils.sendAnalyticsEvent(AnalyticsEvents.settingShareApp);
                                try {
                                  Share.share(Strings.strShareText,
                                      sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width,
                                          MediaQuery.of(context).size.height / 2));
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              },
                            ),
                            buildNetworkDependentTile(
                              context: context,
                              icon: HugeIcons.strokeRoundedDocumentValidation,
                              title: Strings.strTermsOfUse,
                              onAction: () async {
                                Utils.sendAnalyticsEvent(AnalyticsEvents.settingTerms);
                                bool isConnection = await Utils.checkInternet();
                                if (isConnection) {
                                  Utils.launchWebViewInApp(strTermsAndCondition);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Utils.noNetworkDialog(
                                    context,
                                    onRetry: (() {
                                      Navigator.of(context).pop();
                                    }),
                                  );
                                }
                              },
                            ),
                            buildNetworkDependentTile(
                              context: context,
                              icon: HugeIcons.strokeRoundedSecurityCheck,
                              title: Strings.strPrivacyPolicy,
                              onAction: () async {
                                Utils.sendAnalyticsEvent(AnalyticsEvents.settingPrivacy);
                                bool isConnection = await Utils.checkInternet();
                                if (isConnection) {
                                  Utils.launchWebViewInApp(strPrivacyPolicy);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Utils.noNetworkDialog(
                                    context,
                                    onRetry: (() {
                                      Navigator.of(context).pop();
                                    }),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackView()));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: AppTheme.primaryColor.withAlpha(100)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedComment01,
                              size: 20,
                              color: AppTheme.lightFontColor,
                            ),
                            const SizedBox(width: 12.0),
                            Text(
                              Strings.strFeedback,
                              style: TextStyle(
                                fontSize: Sizes.smallFont,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightFontColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          child: IndexedStack(
            index: currentIndex,
            children: const [
              MyHomePage(),
            ],
          ),
        );
      },
    );
  }
}
