import 'package:transcribe/config/config.dart';

class Strings {
  Strings._();

  static const strContactDev = 'Contact Developer';
  static const strContactDevMsg =
      'Facing any issue with transcription? We\'d appreciate your feedback with file size, format, and language to help us improve.';
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
  static const strReviewSubTitle =
      'Thank you for choosing $strAppName! We hope it\'s been useful to you so far. We\'re constantly striving to improve our app and make it the best it can be, which is why we would love to hear your thoughts.';

  static const String strShareText =
      'Transcribe Any Audio Into Text.\n\nPlaystore: $strPlaystoreLink \n\nAppstore: $strAppstoreLink';
  static const String strSubscriptionFooterAndroid =
      '$strAppName requires a subscription fee for access to premium features. The fee will be charged to your Google Play account upon confirmation of purchase. Subscription fees may vary depending on the length of the subscription period selected. You may cancel your subscription at any time through your Google Play account settings.';
  static const String strSubscriptionFooteriOS =
      'Payment will be charged to your Apple ID account at the confirmation of purchase. The subscription will automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period.';

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
  static const String strNoAudioMsg =
      'Convert audio files, such as recordings of interviews into written text for easier reference, analysis, or sharing.';
  static const String strImportAudio = 'Import Audio';
  static const String strSelectLanguage = 'Choose Language';
  static const String strImportAudioFile = 'Import';
  static const String strRecordAudio = 'Record';
  static const String strNoRecordAudio =
      'Effortlessly transcribe audio, including interviews, meetings, or lectures, into written text.';
  static const String strIntroTitle4 = 'Transcribe any audio into text';
  static const String strIntroTitle5 = 'Over 1M Users Trust Us - You Can Too';
  static const String strIntroSubtitle4 =
      'Effortlessly transcribe audio, including interviews, meetings, or lectures, into written text.';
  static const String listFeatures6 = 'Unlimited audio transcription';
  static const String listFeatures7 = 'No Ads';
  static const String bestOffer = 'Best Offer';
  // static const listFeatures = [
  //   '🔄 Unlimited transcriptions',
  //   '📁 Large file support',
  //   '⚡ Faster processing',
  //   '💬 Premium support'
  // ];
  static const listFeatures = [
    "🤖 AI Chatbot — No Limits",
    "📝 Endless Transcriptions",
    "⚡ Instant AI Summaries",
    "🎙️ Record or Import Any Audio",
    "🌍 Supports 100+ Languages",
  ];

  static const listIntroduction = [
    '📂 Upload audio and transcribe',
    '🌍 Supports multiple languages',
    '🎙️ Record and transcribe live',
    '📜 Paragraph-organized transcriptions',
    '🔊 Playback with synced text'
  ];
}

class EnvKeys {
  EnvKeys._();

  static const secretKey = 'SECRET_KEY';
  static const geminiKey = 'GEMINI_KEY';
  static const deepLinkKey = 'DEEPLINK_KEY';
}

class StatusCode {
  StatusCode._();
  static const success = 200;
}

//Images Assets Path
class AssetsPath {
  AssetsPath._();

  static const String imagePath = "assets/images";
  static const String animationPath = "assets/lottie";
  static const String rivePath = "assets/rive";
  static const String audioRive = '$rivePath/record.riv';
  static const String giftjson = '$animationPath/gift1.json';
  static const String loaderJson = '$animationPath/loader.json';
  static const String recording = '$animationPath/recording.json';
  static const String transcribe = "$imagePath/transcribe.png";
  static const String transcribeTwo = "$imagePath/transcribe_two.png";
  static const String transcribeThree = "$imagePath/transcribe_three.png";
  static const String transcribeFour = "$imagePath/transcribe_four.png";
  static const String transcribeFive = "$imagePath/transcribe_five.png";
}

//App Routes
class AppRoutes {
  AppRoutes._();

  static const home = 'home';
  static const intro = 'intro';
  static const tabbar = 'tabbar';
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
}

class AnalyticsEvents {
  AnalyticsEvents._();

  //Home Screen
  static const String recordAudioTap = 'Record_home_Tap';
  static const String importFileTap = 'Import_home_Tap';
  static String selectLanguage(String lang) => 'Choose_Lang_$lang';

  ///Record Screen
  static String startRecord = 'Start_${currentSource.name}_Record';
  static String stopRecord = 'Stop_${currentSource.name}_Record';
  static String saveRecord = 'Save_${currentSource.name}_Record';

  /// Transcription Screen
  static String transcriptionCardTap = 'Trs_${currentSource.name}_Tap';
  static String summaryTap = 'Summary_${currentSource.name}_Tap';
  static String chatBotTap = 'Chatbot_${currentSource.name}_Tap';
  static String editName = 'Menu_${currentSource.name}_Edit_Name';
  static String deleteTranscription = 'Menu_${currentSource.name}_Delete_Trs';
  static String editTranscription = 'Menu_${currentSource.name}_Edit_Full';
  static String editParagraph = 'Edit_${currentSource.name}_Para';
  static String shareFull = 'Share_${currentSource.name}_Full';
  static String sharePara = 'Share_${currentSource.name}_Para';
  static String copyFull = 'Copy_${currentSource.name}_Full';
  static String copyPara = 'Copy_${currentSource.name}_Para';
  static String playFull = 'Play_${currentSource.name}_Full';
  static String playPara = 'Play_${currentSource.name}_Para';
  static String toggleTranscription = 'Toggle_${currentSource.name}_Trs';
  static String editSummary = 'Edit_${currentSource.name}_Summary';
  static String shareSummary = 'Share_${currentSource.name}_Summary';
  static String copySummary = 'Copy_${currentSource.name}_Summary';
  static String sendChat = 'Send_${currentSource.name}_Chat';

  /// Deep Gram API
  static const String deepgramProcess = 'Deepgram_Process';
  static const String deepgramDone = 'Deepgram_Done';
  static const String deepgramCatch = 'Deepgram_Catch';

  /// Onboarding
  static const String obView = 'Ob_View';
  static const String obDone = 'Ob_Done';
  static const String helpUsReview = 'Help_Us_Tap';

  static String get sourceView => '${currentSource.name}_View';
  static String get sourceClose => '${currentSource.name}_Close';

  /// Settings
  static const String subscription = 'Subscription_Card';
  static const String settingTerms = 'Settings_Terms_Of_Use';
  static const String settingPrivacy = 'Settings_Privacy_Policy';
  static const String settingRateApp = 'Settings_Rate_App';
  static const String settingLanguage = 'Settings_Language';
  static const String settingFeedback = 'Settings_Feedback';
  static const String settingShareApp = 'Settings_Share_App';

  /// Subscription Screen
  static String get proSourceView => 'Pro_${currentSource.name}_View';
  static String get proSourceAccess => 'Pro_${currentSource.name}_Limit';
  static String get proSIdTap => 'Pro_${currentSource.name}_${currentID}_Tap';
  static String get proSIdSuccess => 'Pro_${currentSource.name}_${currentID}_Success';
  static String get proSClose => 'Pro_${currentSource.name}_Close';
  static String get proSIdFailure => 'Pro_${currentSource.name}_${currentID}_Failure';

  /// Trial Paywall
  static String get trialSourceView => 'Trial_${currentSource.name}_View';
  static String get trialSourceAccess => 'Trial_${currentSource.name}_Limit';
  static String get trialSIdTap => 'Trial_${currentSource.name}_${currentID}_Tap';
  static String get trialSIdSuccess => 'Trial_${currentSource.name}_${currentID}_Success';
  static String get trialSClose => 'Trial_${currentSource.name}_Close';
  static String get trialSIdFailure => 'Trial_${currentSource.name}_${currentID}_Failure';
}

//Source Flow
enum Source {
  ob,
  settings,
  home,
  history,
  file,
  record,
}

//Source Flow

Source currentSource = Source.ob;

//Subscription Package ID
String currentID = '';
