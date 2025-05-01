import 'package:transcribe/config/config.dart';

class Strings {
  Strings._();

  static const strContactDev = 'Contact Developer';
  static const strContactDevMsg = 'Facing any issue with transcription? We\'d appreciate your feedback with file size, format, and language to help us improve.';
  // offer screen string
  static const strTabHome = 'Transcibe';
  static const strTabSetting = 'Settings';
  static const strSend = 'Send';
  static const strPrivacyPolicy = 'Privacy Policy';
  static const strTermsOfUse = 'Terms of Use';
  static const strShareApp = 'Share Our App';
  static const strRateApp = 'Rate Our App';
  static const strFeedback = 'Write Your Feedback';
  static const strSubscribe = 'Continue';
  static const strUpgrade = 'UPGRADE TO PREMIUM';
  static const strEnjoyAccess = 'Enjoy unlimited transcriptions and many more features.';
  static const strSkip = 'skip';
  static const strWeekly = 'Weekly';
  static const strWeeklyTrial = 'Weekly (3 Days Free Trial)';
  static const strMonthly = 'Monthly';
  static const strLifetime = 'Lifetime';
  static const strYearly = 'Yearly';
  static const strPremiumUser = '$strAppName Pro';
  static const strRestorePurchase = 'Restore Purchases';
  static const strWeeklySubtitle = 'Starter';
  static const strChipTitle = 'Save 90%';
  static const strMonthlySubtitle = 'Save 38%';
  static const strYearlySubtitle = 'Unlimited Access';
  static const strEnjoySubscription = 'Enjoy Your Subscription';
  static const strSomethingWentWrong = 'Something Went Wrong';
  static const strTryAgainLater = 'Please try again later';
  static const strNoNetwork = 'No Network';
  static const strNoInternetConnectionMessage = 'Please check your internet connection and try again.';
  static const strUpgradePremium = 'Upgrade to premium';
  static const strOr = 'Or';
  static const strDone = 'Done';
  static const strRetry = 'Retry';
  static const strSubscribeToast = 'Please subscribe in order to access all of the features.';
  static const strLanguageTitle = 'Change Language';
  static const strSave = 'Save';
  static const strHelp = 'Rate Now';
  static const strReviewTitle = 'Help us to improve!';
  static const strReviewSubTitle = 'Thank you for choosing $strAppName! We hope it\'s been useful to you so far. We\'re constantly striving to improve our app and make it the best it can be, which is why we would love to hear your thoughts.';

  // static const String strShareText =
  //     'Transcribe Any Audio Into Text.\n\nPlaystore: $strPlaystoreLink \n\nAppstore: $strAppstoreLink';TODO
  static const String strSubscriptionFooterAndroid = '$strAppName requires a subscription fee for access to premium features. The fee will be charged to your Google Play account upon confirmation of purchase. Subscription fees may vary depending on the length of the subscription period selected. You may cancel your subscription at any time through your Google Play account settings.';
  static const String strSubscriptionFooteriOS = 'Payment will be charged to your Apple ID account at the confirmation of purchase. The subscription will automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period.';

  static const String strChatAlertTitle = 'Do you want to clear all audio list?';
  static const String strChatAlertSubTitle = 'This action can\'t be undone';
  static const String strNo = 'No';
  static const String strYes = 'Yes';
  static const String strHistoryTitle = 'Do you want to clear chat?';
  static const String strGrantAudioPermission = 'Please grant record audio permission in system settings.';
  static const String strFreeTrial = 'Try For Free';
  static const String strAudioToText = 'Audio To Text';
  static const String strNoResultFound = 'No Result Found';
  static const String strLargeFile = 'The file you are trying to upload is too large.';
  static const String strNoAudioMsg = 'Convert audio files, such as recordings of interviews into written text for easier reference, analysis, or sharing.';
  static const String strImportAudio = 'Import Audio';
  static const String strSelectLanguage = 'Choose Language';
  static const String strImportAudioFile = 'Import';
  static const String strRecordAudio = 'Record';
  static const String strNoRecordAudio = 'Effortlessly transcribe audio, including interviews, meetings, or lectures, into written text.';
  static const String strIntroTitle4 = 'Transcribe any audio into text';
  static const String strIntroTitle5 = 'Over 1M Users Trust Us - You Can Too';
  static const String strIntroSubtitle4 = 'Effortlessly transcribe audio, including interviews, meetings, or lectures, into written text.';
  static const String listFeatures6 = 'Unlimited audio transcription';
  static const String listFeatures7 = 'No Ads';
  static const String bestOffer = 'Best Offer';
  static const listFeatures = ['🔄 Unlimited transcriptions', '📁 Large file support', '⚡ Faster processing', '💬 Premium support'];
  static const listIntroduction = ['📂 Upload audio and transcribe', '🌍 Supports multiple languages', '🎙️ Record and transcribe live', '📜 Paragraph-organized transcriptions', '🔊 Playback with synced text'];
}

class EnvKeys {
  EnvKeys._();
  static const deepLinkKey = 'DEEPLINK_KEY';
}

class StatusCode {
  StatusCode._();
  static const success = 200;
}

//Images Assets Path
class AssetsPath {
  AssetsPath._();

  static String imagePath = "assets/images";
  static String animationPath = "assets/lottie";
  static String rivePath = "assets/rive";
  static String audioRive = '$rivePath/record.riv';

  static String giftjson = '$animationPath/gift1.json';
  static String loaderJson = '$animationPath/loader.json';
  static String recording = '$animationPath/recording.json';
}

//App Routes
class AppRoutes {
  AppRoutes._();

  static const home = 'home';
  static const intro = 'intro';
  static const tabbar = 'tabbar';
  static const setting = 'setting';
  static const history = 'history';
  static const subscription = 'subscription';
}

//Keys
class Keys {
  Keys._();

  static const String keyError = 'error';
  static const String keyMessage = 'message';
  static const String keyData = 'data';
  static const String keyToken = 'token';
  static const String keyType = 'type';
  static const String keyCode = 'code';
  static const String keyInsufficientQuota = 'insufficient_quota';
  static const String keyContextLengthExceeded = "context_length_exceeded";
  static const String keyInvalidAPIKey = "invalid_api_key";
  static const String keyModel = 'model';
  static const String keyAuthorization = 'Authorization';
  static const String keyContentType = 'Content-Type';
  static const String keyClientSecret = 'CustomKey';
  static const String keyApplicationJson = 'application/json';
  static const String keyMessages = 'messages';
  static const String keyN = 'n';
  static const String keyRole = 'role';
  static const String keyContent = 'content';
  static const String keyImage = 'image';
  static const String keyUser = 'user';
  static const String keyAssistant = 'assistant';
  static const String keyChoices = 'choices';
  static const String keyPrompt = "prompt";
  static const String keySize = "size";
  static const String keyMaxTokens = "max_tokens";
  static const String keyText = "text";
  static const String keyMsg = "msg";
  static const String keyChatIndex = "chatIndex";
  static const String keyId = "id";
  static const String keyRoot = "root";
  static const String keyCreated = "created";
  static const String keyURL = "url";
  static const String keyLanguage = "language";
  static const String keyFile = 'file';
  static const String keyTrue = 'true';
  static const String keyAppUpdate = 'update';

  //subscription screen
  static const String keyDuration = 'duration';
  static const String keyAmount = 'amount';

  //Hive Keys
  static const String keyBoxUser = 'boxuser';
  static const String keyBoxHistory = 'boxhistory';
  static const String keyBoxAudio = 'boxaudio';
  static const String keyUserID = 'userid';
  static const String keyHistoryID = 'historyid';
  static const String keyAudioID = 'audioid';

  //Analytics
  static const String strAnlSubscription = 'Subscription_Card';
  static const String strAnlAudio = 'Audio';
  static const String strAnlSettingTerms = 'Settings_Terms_Of_Use';
  static const String strAnlSettingPrivacy = 'Settings_Privacy_Policy';
  static const String strAnlSettingRateApp = 'Settings_Rate_App';
  static const String strAnlSettingLanguage = 'Settings_Language';
  static const String strAnlSettingFeedback = 'Settings_Feedback';
  static const String strAnlSettingShareApp = 'Settings_Share_App';
  static const String strAnlPurchasePlan = 'Purchase_plan';
  static const String strAnlAudioDone = 'Audio_Done';
  static const String strAnlHelpUsReview = 'Clicked_on_help_us_review';
  static const String strAnlHistoryChecked = 'History_Checked';
  static const String strAnlAudioChecked = 'Audio_checked';
  static const String strAnlDeepgramProcess = 'Deepgram_process';
  static const String strAnlDeepgramDone = 'Deepgram_done';
  static const String strAnlDeepgramCatch = 'Deepgram_catch';
  static String strAnlAudioServerProcess = 'Audio_Server_Process';
  static String strAnlAudioServerDone = 'Audio_Server_Done';

  static const String strAnlOb1View = 'Ob1_view';
  static const String strAnlObView = 'Ob_view';
  static const String strAnlObDone = 'Ob_done';

//Source View
  static String get sourceView => '${currentSource.name}_view';

//Subscription Screen
  static String get proSourceView => 'Pro_${currentSource.name}_view';
  static String get proSourceAccess => 'Pro_${currentSource.name}_limit';
  static String get proSIdTap => 'Pro_${currentSource.name}_${currentID}_Tap';
  static String get proSIdSuccess => 'Pro_${currentSource.name}_${currentID}_success';
  static String get proSClose => 'Pro_${currentSource.name}_close';
  static String get proSIdFailure => 'Pro_${currentSource.name}_${currentID}_failure';
}

//Source Flow
enum Source { ob, settings, home, opened, launch, card, audio, record, image }

Source currentSource = Source.ob;

//Subscription Package ID
String currentID = '';
