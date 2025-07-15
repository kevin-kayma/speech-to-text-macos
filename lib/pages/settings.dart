// import 'package:transcribe/components/components.dart';
// import 'package:transcribe/config/config.dart';
// import 'package:transcribe/pages/feedback.dart';

// class Settings extends ConsumerStatefulWidget {
//   const Settings({Key? key}) : super(key: key);

//   @override
//   ConsumerState<Settings> createState() => _SettingsState();
// }

// class _SettingsState extends ConsumerState<Settings> {
//   @override
//   void initState() {
//     super.initState();
//     currentSource = Source.settings;
//     Utils.sendAnalyticsEvent(AnalyticsEvents.sourceView);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text(Strings.strTabSetting)),
//       body: ListView(
//         padding: const EdgeInsets.all(12),
//         children: <Widget>[
//           FutureBuilder(
//             builder: (ctx, snapshot) {
//               return snapshot.data ?? const SizedBox();
//             },
//             future: subscriptionCard(context),
//           ),
//           const SizedBox(height: 15),
//           Column(
//             children: [
//               ClickableCard(
//                 onTap: () async {
//                   Utils.sendAnalyticsEvent(Keys.strAnlSettingRateApp);
//                   bool isConnection = await Utils.checkInternet();
//                   if (isConnection) {
//                     Utils.openStoreReview();
//                   } else {
//                     // ignore: use_build_context_synchronously
//                     Utils.noNetworkDialog(context, onRetry: (() {
//                       Navigator.of(context).pop();
//                     }));
//                   }
//                 },
//                 child: ListTile(
//                   title: Text(Strings.strRateApp),
//                   leading: HugeIcon(
//                     icon: HugeIcons.strokeRoundedStar,
//                     color: AppTheme.lightFontColor,
//                   ),
//                   trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppTheme.lightFontColor),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               ClickableCard(
//                 onTap: () async {
//                   Utils.sendAnalyticsEvent(Keys.strAnlSettingFeedback);
//                   // Utils.launchWebViewInApp(
//                   //     'mailto:$strFeedbackEmail?subject=Feedback for $strAppName');
//                   bool isConnection = await Utils.checkInternet();
//                   if (isConnection) {
//                     // ignore: use_build_context_synchronously
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const FeedbackView()),
//                     );
//                   } else {
//                     // ignore: use_build_context_synchronously
//                     Utils.noNetworkDialog(context, onRetry: (() {
//                       Navigator.of(context).pop();
//                     }));
//                   }
//                 },
//                 child: ListTile(
//                   title: Text(Strings.strFeedback),
//                   leading: HugeIcon(icon: HugeIcons.strokeRoundedPenTool01, color: AppTheme.lightFontColor),
//                   trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppTheme.lightFontColor),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               ClickableCard(
//                 onTap: () async {
//                   Utils.sendAnalyticsEvent(Keys.strAnlSettingShareApp);
//                   try {
//                     Share.share(Strings.strShareText,
//                         sharePositionOrigin: Rect.fromLTWH(
//                             0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height / 2));
//                   } catch (e) {
//                     debugPrint(e.toString());
//                   }
//                 },
//                 child: ListTile(
//                   title: const Text(Strings.strShareApp),
//                   leading: HugeIcon(icon: HugeIcons.strokeRoundedShare01, color: AppTheme.lightFontColor),
//                   trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppTheme.lightFontColor),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Column(
//             children: [
//               ClickableCard(
//                 onTap: () async {
//                   Utils.sendAnalyticsEvent(Keys.strAnlSettingTerms);
//                   bool isConnection = await Utils.checkInternet();
//                   if (isConnection) {
//                     Utils.launchWebViewInApp(strTermsAndCondition);
//                   } else {
//                     // ignore: use_build_context_synchronously
//                     Utils.noNetworkDialog(context, onRetry: (() {
//                       Navigator.of(context).pop();
//                     }));
//                   }
//                 },
//                 child: ListTile(
//                   title: const Text(Strings.strTermsOfUse),
//                   leading: HugeIcon(icon: HugeIcons.strokeRoundedDoc01, color: AppTheme.lightFontColor),
//                   trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppTheme.lightFontColor),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               ClickableCard(
//                 onTap: () async {
//                   Utils.sendAnalyticsEvent(Keys.strAnlSettingPrivacy);
//                   bool isConnection = await Utils.checkInternet();
//                   if (isConnection) {
//                     Utils.launchWebViewInApp(strPrivacyPolicy);
//                   } else {
//                     // ignore: use_build_context_synchronously
//                     Utils.noNetworkDialog(context, onRetry: (() {
//                       Navigator.of(context).pop();
//                     }));
//                   }
//                 },
//                 child: ListTile(
//                   title: const Text(Strings.strPrivacyPolicy),
//                   leading: HugeIcon(icon: HugeIcons.strokeRoundedDoc02, color: AppTheme.lightFontColor),
//                   trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppTheme.lightFontColor),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
