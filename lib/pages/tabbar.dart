import 'package:flutter/material.dart';
import 'package:transcribe/components/components.dart';
import 'package:transcribe/pages/pages.dart';
import 'package:transcribe/config/config.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({
    Key? key,
    this.index = 0, // Optional field with default value
  }) : super(key: key);

  final int index;

  @override
  TabbarState createState() => TabbarState();
}

class TabbarState extends State<Tabbar> {
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
                                ? Divider(
                                    color: AppTheme.greyFontColor,
                                  )
                                : const SizedBox(),
                            // buildSidebarTile(
                            //   icon: HugeIcons.strokeRoundedVoice,
                            //   title: strAppName,
                            //   onTap: () => setState(() => currentIndex = 0),
                            //   selected: currentIndex == 0,
                            // ),
                            // Divider(
                            //   color: AppTheme.greyFontColor,
                            // ),
                            buildNetworkDependentTile(
                              context: context,
                              icon: HugeIcons.strokeRoundedMagicWand02,
                              title: Strings.strRateApp,
                              onAction: () async {
                                Utils.sendAnalyticsEvent(Keys.strAnlSettingRateApp);
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
                                Utils.sendAnalyticsEvent(Keys.strAnlSettingShareApp);
                                try {
                                  Share.share(Strings.strShareText, sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height / 2));
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
                                Utils.sendAnalyticsEvent(Keys.strAnlSettingTerms);
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
                                Utils.sendAnalyticsEvent(Keys.strAnlSettingPrivacy);
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
                        Utils.launchWebViewInApp(strFeedbackURL);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: AppTheme.primaryColor.withAlpha(100)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedComment01,
                              size: 20,
                              color: AppTheme.lightFontColor,
                            ),
                            const SizedBox(width: 12.0),
                            Text(
                              Strings.strFeedback,
                              style: TextStyle(
                                fontSize: Sizes.mediumFont,
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
            children: [
              MyHomePage(),
            ],
          ),
        );
      },
    );
  }
}
