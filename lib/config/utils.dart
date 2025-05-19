import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:transcribe/config/config.dart';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:transcribe/models/models.dart';
import 'package:transcribe/pages/pages.dart';
import 'package:transcribe/providers/providers.dart';

enum CanAccess { query, image, audio, recordaudio }

class Utils {
  Utils._();

  static Widget dialogAppBar(String title, BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.close,
            color: AppTheme.greyFontColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
      title: Text(
        title,
        maxLines: 2,
        style: TextStyle(
            fontSize: Sizes.mediumFont,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightFontColor),
      ),
    );
  }

  static scrollListToEND(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.ease);
    }
  }

//To launch web URL into the web browser.
  static launchWebViewInApp(String url) async {
    final uri = Uri.parse(url);

    await launchUrl(uri);
  }

  //User info methods
  static addUser(
      {int? intQueries,
      int? intImages,
      int? intAudio,
      int? intRecordAudio,
      int? intChatReview,
      int? intImageReview,
      int? intShare,
      int? intCopy,
      int? intImageQuantity,
      String? strImageSize,
      bool? isDismissImageSetting,
      bool? isIntroLoaded,
      String? strAlertID}) {
    final user = Boxes.getUser();
    final myuser = user.get(Keys.keyUserID);

    if (myuser == null) {
      final userInfo = User()
        ..intQueries = intQueries ?? 0
        ..intImages = intImages ?? 0
        ..intAudio = intAudio ?? 0
        ..intRecordAudio = intRecordAudio ?? 0
        ..intChatReview = intChatReview ?? 0
        ..intImageReview = intImageReview ?? 0
        ..intShare = intShare ?? 0
        ..intCopy = intCopy ?? 0
        ..intImageQuantity = intImageQuantity ?? 0
        ..isDismissImageSetting = isDismissImageSetting ?? false
        ..isIntroLoaded = isIntroLoaded ?? false
        ..strImageSize = strImageSize ?? '256x256'
        ..strAlertID = strAlertID ?? '';

      user.put(Keys.keyUserID, userInfo);
    } else {
      final userInfo = User()
        ..intQueries = intQueries ?? myuser.intQueries
        ..intAudio = intAudio ?? myuser.intAudio
        ..intRecordAudio = intRecordAudio ?? myuser.intRecordAudio
        ..intImages = intImages ?? myuser.intImages
        ..intImageReview = intImageReview ?? myuser.intImageReview
        ..intChatReview = intChatReview ?? myuser.intChatReview
        ..intShare = intShare ?? myuser.intShare
        ..intCopy = intCopy ?? myuser.intCopy
        ..intImageQuantity = intImageQuantity ?? myuser.intImageQuantity
        ..isDismissImageSetting =
            isDismissImageSetting ?? myuser.isDismissImageSetting
        ..isIntroLoaded = isIntroLoaded ?? myuser.isIntroLoaded
        ..strImageSize = strImageSize ?? myuser.strImageSize
        ..strAlertID = strAlertID ?? myuser.strAlertID;

      user.put(Keys.keyUserID, userInfo);
    }
  }

  //Delete user from db
  static deleteUser(User user) {
    user.delete();
  }

//Refresh subscription
  static refreshSubscription() async {
    if (kDebugMode) {
      // isUserSubscribed = true;
    } else {
      if (await Purchases.isConfigured) {
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        (customerInfo.entitlements.all[entitlementID] != null &&
                (customerInfo.entitlements.all[entitlementID]?.isActive ??
                    false))
            ? isUserSubscribed = true
            : isUserSubscribed = false;
      } else {
        debugPrint('Not configured');
      }
    }
  }

  static checkTrial(List<String> productIdentifiers) async {
    if (await Purchases.isConfigured) {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        offerings.current?.availablePackages.forEach((element) async {
          final identifier = element.storeProduct.identifier;
          final introEligibility =
              await Purchases.checkTrialOrIntroductoryPriceEligibility(
            [identifier],
          );

          final status = introEligibility[identifier]?.status;
          switch (status) {
            case IntroEligibilityStatus.introEligibilityStatusEligible:
              debugPrint(IntroEligibilityStatus.introEligibilityStatusEligible
                  .toString());
              break;
            // showToast('introEligibilityStatusEligible');

            case IntroEligibilityStatus.introEligibilityStatusIneligible:
              debugPrint(IntroEligibilityStatus.introEligibilityStatusEligible
                  .toString());
              break;
            case IntroEligibilityStatus
                  .introEligibilityStatusNoIntroOfferExists:
              debugPrint(IntroEligibilityStatus
                  .introEligibilityStatusNoIntroOfferExists
                  .toString());
              break;

            case IntroEligibilityStatus.introEligibilityStatusUnknown:
              debugPrint(IntroEligibilityStatus.introEligibilityStatusUnknown
                  .toString());
              break;

            default:
              debugPrint(IntroEligibilityStatus.introEligibilityStatusUnknown
                  .toString());
              break;
          }
        });
      }
    } else {
      debugPrint('Not configured');
      return IntroEligibilityStatus.introEligibilityStatusUnknown;
    }
  }

  //Does user can acceess premium feature or not
  static bool isCanAccess(CanAccess canAccess) {
    final user = Boxes.getUser();
    final userInfo = user.get(Keys.keyUserID);
    final isNotPremium = !isUserSubscribed;

    switch (canAccess) {
      case CanAccess.audio:
        if (userInfo != null) {
          if (isNotPremium && (userInfo.intAudio ?? 0) >= intMaxAudio) {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      case CanAccess.recordaudio:
        if (userInfo != null) {
          if (isNotPremium &&
              (userInfo.intRecordAudio ?? 0) >= intMaxRecordAudio) {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      default:
        return true;
    }
  }

//Review
  static openStoreReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.openStoreListing(appStoreId: strAppStoreID);
    }
  }

  static openReviewDialog() async {
    final InAppReview inAppReview = InAppReview.instance;

    Future.delayed(const Duration(seconds: 1), () async {
      inAppReview.requestReview();
    });
  }

//Google Analytics
  static Future<void> sendAnalyticsEvent(String eventName,
      [Map<String, Object>? eventValue]) async {
    if (!kDebugMode) {
      // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      // await analytics.logEvent(
      //   name: eventName,
      //   parameters: eventValue,
      // );TODO:
    } else {
      debugPrint(eventName);
    }
  }

//Check Internet connection
  static Future<bool> checkInternet() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool result = await InternetConnectionChecker().hasConnection;
      return result;
    } on PlatformException catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  static Future<void> errorFeedbackDialog(
    BuildContext context,
  ) async {
    Future<void> future = showModalBottomSheet<void>(
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: AppTheme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  Strings.strContactDev,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Sizes.mediumFont,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightFontColor),
                ),
                const SizedBox(height: 12),
                Text(
                  Strings.strContactDevMsg,
                  textAlign: TextAlign.center,
                  maxLines: 6,
                  style: TextStyle(
                      fontSize: Sizes.mediumFont,
                      color: AppTheme.greyFontColor),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeedbackView()),
                        );
                      },
                      child: Text(
                        Strings.strSend.toUpperCase(),
                        style: TextStyle(color: AppTheme.darkFontColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme
                            .greyBackgroundColor, // Set the background color here
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'CLOSE',
                        style: TextStyle(color: AppTheme.lightFontColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );

    return future;
  }

  static Future<void> noNetworkDialog(
    BuildContext context, {
    required VoidCallback onRetry,
  }) async {
    Future<void> future = showModalBottomSheet<void>(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: AppTheme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  Strings.strNoNetwork,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Sizes.mediumFont,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightFontColor),
                ),
                const SizedBox(height: 12),
                Text(
                  Strings.strNoInternetConnectionMessage,
                  textAlign: TextAlign.center,
                  maxLines: 6,
                  style: TextStyle(
                      fontSize: Sizes.mediumFont,
                      color: AppTheme.greyFontColor),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onRetry,
                  child: Text(
                    Strings.strRetry.toUpperCase(),
                    style: TextStyle(color: AppTheme.darkFontColor),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );

    return future;
  }

  static Future<void> initMessageDialog(
    BuildContext context, {
    required InitAlertData initAlertData,
  }) async {
    //if alert from database is true
    //if alert dismiss from database is false and version from api is not equal to database appversion
    //display alert
    //if alert dismiss from database is false and version from api is equad to database appversion
    //do nothing
    //if alert dismiss from database is true and version from api is equal to database appversion
    //do nothing
    //if alert dismiss from database is true and version from api isnot equal to database appversion
    // display alert
    // if alert from database is false
    //do nothing

    //if version from api is not equal to database appversion && apiversion not is blank
    //display alert
    //if version from api is equad to database appversion
    //do nothing

    Future<void> future = showModalBottomSheet<void>(
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Container(
          color: AppTheme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (initAlertData.isForcefullyUpdate == Keys.keyTrue)
                    ? Text(
                        initAlertData.title ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: Sizes.mediumFont,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightFontColor),
                      )
                    : AppBar(
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        centerTitle: true,
                        backgroundColor: AppTheme.scaffoldBackgroundColor,
                        foregroundColor: AppTheme.lightFontColor,
                        actions: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: AppTheme.greyFontColor,
                            ),
                            onPressed: () {
                              Utils.addUser(strAlertID: initAlertData.alertID);
                              if (initAlertData.isForcefullyUpdate !=
                                  Keys.keyTrue) {
                                Navigator.pop(context);
                              }
                            },
                          )
                        ],
                        title: Text(
                          initAlertData.title ?? "",
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: Sizes.mediumFont,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                const SizedBox(height: 12),
                Text(
                  initAlertData.desc ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  style: TextStyle(
                      fontSize: Sizes.mediumFont,
                      color: AppTheme.greyFontColor),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Utils.addUser(strAlertID: initAlertData.alertID);

                    if (initAlertData.msgAction == Keys.keyAppUpdate) {
                      if (Platform.isAndroid) {
                        OpenStore.instance.open(
                          androidAppBundleId:
                              strPlayStoreID, // Android app bundle package name
                        );
                      } else {
                        OpenStore.instance.open(
                          appStoreId:
                              strAppStoreID, // AppStore id of your app for iOS
                        );
                      }
                    }
                    if (initAlertData.isForcefullyUpdate != Keys.keyTrue) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    initAlertData.msgActionButtonTitle?.toUpperCase() ?? '',
                    style: TextStyle(color: AppTheme.darkFontColor),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );

    return future;
  }

  static Future<void> reviewDialog(BuildContext context) async {
    Future<void> future = showModalBottomSheet<void>(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: AppTheme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Utils.dialogAppBar(Strings.strReviewTitle, context),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Icon(Icons.star, color: Colors.yellow),
                    Icon(Icons.star, color: Colors.yellow),
                    Icon(Icons.star, color: Colors.yellow),
                    Icon(Icons.star, color: Colors.yellow),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  Strings.strReviewSubTitle,
                  textAlign: TextAlign.center,
                  maxLines: 6,
                  style: TextStyle(
                      fontSize: Sizes.mediumFont,
                      color: AppTheme.greyFontColor),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Utils.sendAnalyticsEvent(Keys.strAnlHelpUsReview);
                    Navigator.pop(context);
                    Utils.openReviewDialog();
                    // Utils.openStoreReview();// TODO:
                  },
                  child: Text(
                    Strings.strHelp,
                    style: TextStyle(color: AppTheme.darkFontColor),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
    return future;
  }

  static showWarning(
      {required void Function()? onYes,
      required void Function()? onNo,
      required String strTitle,
      required String strSubTitle,
      required BuildContext context}) {
    showModalBottomSheet<void>(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: AppTheme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  strTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Sizes.mediumFont,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightFontColor),
                ),
                const SizedBox(height: 12),
                Text(
                  strSubTitle,
                  textAlign: TextAlign.center,
                  maxLines: 6,
                  style: TextStyle(
                      fontSize: Sizes.mediumFont,
                      color: AppTheme.greyFontColor),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.greyBackgroundColor,
                      ),
                      onPressed: onNo,
                      child: Text(
                        Strings.strNo,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: onYes,
                      child: Text(
                        Strings.strYes,
                        style: TextStyle(color: AppTheme.darkFontColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  //Date
  static String getCurrentDateAndTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM yyyy | HH:mm ').format(now);
    return formattedDate;
  }

  //Files
  static Future<String> getDirectory() async {
    Directory directory = Directory("");
    directory = await getApplicationDocumentsDirectory();
    final exPath = '${directory.path}/whisper.wav';
    return exPath;
  }

  static Future<String> getFilepath(String filePath) async {
    if (Platform.isAndroid) {
      return filePath;
    }
    String filename = basename(filePath);
    try {
      // Get the base Documents Directory path
      final documentsDir = await getApplicationDocumentsDirectory();

      // Reconstruct the full file path
      String fullPath = '${documentsDir.path}/$filename';

      // Check if the file exists
      final file = File(fullPath);

      if (await file.exists()) {
        return file.path;
      } else {
        // Reconstruct the full file path
        final tmpDir = Directory.systemTemp;

        // Check if the file exists
        String tempPath = '${tmpDir.path}/$filename';
        final file = File(tempPath);
        if (await file.exists()) {
          return file.path;
        }
        return '';
      }
    } catch (e) {
      debugPrint('Error while checking file existence: $e');
      return '';
    }
  }

  static Future<String> getAudioPath(String filePath) async {
    try {
      final fileName = basename(filePath);

      // Look in the app's temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/$fileName';
      final tempFile = File(tempFilePath);
      if (await tempFile.exists()) {
        return tempFile.path;
      }

      // Look in the app's documents directory
      final documentsDir = await getApplicationDocumentsDirectory();
      final docFilePath = '${documentsDir.path}/$fileName';
      final docFile = File(docFilePath);
      if (await docFile.exists()) {
        return docFile.path;
      }

      return ''; // File not found in either location
    } catch (e) {
      debugPrint('Error while checking file existence: $e');
      return '';
    }
  }

  static Future<String> checkFileExist(String filePath) async {
    String filename = basename(filePath);
    try {
      // Check if the file exists
      final file = File(filePath);

      if (await file.exists()) {
        return file.path;
      } else {
        // Reconstruct the full file path
        final tmpDir = Directory.systemTemp;

        // Check if the file exists
        String tempPath = '${tmpDir.path}/$filename';
        final file = File(tempPath);
        if (await file.exists()) {
          return file.path;
        }
        return '';
      }
    } catch (e) {
      debugPrint('Error while checking file existence: $e');
      return '';
    }
  }

  static Future<void> sendErrorToSlack(String errorMessage,
      {String? statusCode = 'Nil'}) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String os = 'Macos';

      final fullErrorMessage = '''
       App: $strAppName
          Error Message: $errorMessage
          Status Code: $statusCode
          Version: $version
          os: $os
      ''';
      if (kDebugMode) {
        debugPrint('$fullErrorMessage from sendErrorToSlack');
      } else {
        await slack.send(fullErrorMessage, channel: channelName);
      }
    } catch (e) {
      debugPrint('An error occurred while sending error to Slack: $e');
    }
  }

  // Future<void> convertAndCompressToMp3(
  //     String inputPath, String outputPath) async {
  //   final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  //   // Adjust the bitrate according to your needs (e.g., 64k, 128k, 192k)
  //   int bitrate = 128;

  //   String command =
  //       "-i $inputPath -codec:a libmp3lame -b:a ${bitrate}k $outputPath";
  //   int result = await _flutterFFmpeg.execute(command);
  //   print("FFmpeg process exited with code $result");
  // }
  static String getDecodedSecretKey(String string) {
    final encodedKey = dotenv.env[string];
    if (encodedKey == null) {
      throw Exception("SECRET_KEY not found in .env");
    }
    final bytes = base64Decode(encodedKey);
    return utf8.decode(bytes);
  }

  static Future<void> checkReview() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    inReview = initAlertData.isUpdated == Keys.keyTrue &&
        version == initAlertData.appVersion;
    debugPrint(inReview.toString());
  }

  static bool isFutureDateReached() {
    DateTime currentDate = DateTime.now();
    return !currentDate.isBefore(targetDate);
  }
}
