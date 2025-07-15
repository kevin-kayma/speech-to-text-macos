//Basic Details
import 'package:transcribe/config/config.dart';

const String strAppName = 'Transcribe';
String strFeedbackEmail = "fireboltonline@gmail.com";
const String strPlaystoreLink = 'Coming soon';
const String strAppstoreLink = 'https://apps.apple.com/us/app/transcriber-speech-to-text/id6739805580';
String strFeedbackURL =
    'https://docs.google.com/forms/d/e/1FAIpQLSd8Tv76gZ17MoSfsPQ3n-XAfmAvnyYHA_t-wT3PdPFNpnH27w/viewform';
String strAppStoreID = '6739805580';
String strPlayStoreID = '';
const String fontFamily = 'Karla';

//Slack
final slack = SlackNotifier('https://hooks.slack.com/services/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');
const String channelName = 'api-error';

//RevenueCat Setup
//Entitlement ID from the RevenueCat dashboard that is activated upon successful in-app purchase for the duration of the purchase.
String entitlementID = 'pro';
const appleApiKey = 'appl_JaodxmiiCaQXJyAxkGrWcQppbfX';

//Add the Google API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
const googleApiKey = '';

//Subscription Period
const String strProductWeekly = 'P1W';
const String strProductMonthly = 'P1M';
const String strProductYearly = 'P1Y';

//URLs
const String strTermsAndCondition = 'https://sites.google.com/view/transcriberspeechtotext/terms-of-use';
const String strPrivacyPolicy = 'https://sites.google.com/view/transcriberspeechtotext/privacy-policy';

//ChatGPT
// String apiKey = '';
// String backupAPIKey = '';
// String serverAPIKey = "";
// const String whisper1 = 'whisper-1';

//Deeplink Key
String deepLinkKey = dotenv.env[EnvKeys.deepLinkKey] ?? '';

//Initiate API
String strInitiOSURL = 'https://firebasestorage.googleapis.com/v0/b/json-23e66.appspot.com/o/transcribe.json?alt=media';

String strInitAndroidURL =
    'https://firebasestorage.googleapis.com/v0/b/json-23e66.appspot.com/o/transcribe.json?alt=media';

//Swagger API URLs
const String urlSwTranscriptions = "https://api.firebolt.co.in/api/Home/Transcriptions";
const String urlSwGetToken = "https://api.firebolt.co.in/api/Authentication/GetTokenValue";

//Network URLs
String urlTranscriptions = "https://api.openai.com/v1/audio/transcriptions";

//Image Result Size & Count

//Languagess
const Map<String, String> listLanguages = {
  'Auto Detect': '', //English
  'English': 'en', //English
  'Deutsch': 'de', //German
  'Français': 'fr', //French
  '中文': 'zh', //China
  '日本': 'ja', //Japanese
  'Português': 'pt', //Portuguese
  'Русский': 'ru', //Russian
  'Española': 'es', //Spanish
  'हिंदी': 'hi', //Hindi
  '한국인': 'ko', //Korean
  'Nederlands': 'nl', //Dutch
  'italiana': 'it', //Italian
  'Svenska': 'sv', //Sweden
};

//Widget Sizes
double intBorderRadius = 12;

//Premium Validation Counts
int intMaxAudio = 2;
int intMaxRecordAudio = 2;

DateTime targetDate = DateTime(2024, 6, 25);

const int maxTokens = 2000;

//Review Max Counts
const int intMaxReviewsChat = 33;

const int intMaxTokens = 10;

int maxChatCount = 0;
int maxSummaryCount = 0;

//Google Ads
const int maxFailedLoadAttempts = 3;
//ChatGPT
String apiKey = '';
String backupAPIKey = '';
String serverAPIKey = "";
const String chatGPTModel = "gpt-4o-mini";
const String chatGPTImageModel = "gpt-4o";

const String urlSwVision = "https://api.firebolt.co.in/api/Home/Vision";

int maxFailedAttemptServer = 3;
int failedAttemptServer = 0;

//Sizes
class Sizes {
  Sizes._();

  //Height / Width
  static double spacerHeight = 17.sp;
  static double buttonHeight = 44;
  static double textFieldHeight = 6.h;
  static double indicatorHeight = 3.h;
  static double mediumHeight = 5.h;
  static double largeHeight = 7.h;
  static double cardHeight = 38.sp;
  static double extraLargeHeight = 9.h;
  static double largeTextHeight = 15.h;
  static double smallHeight = 4.h;
  static double extraSmallHeight = 3.h;

  static double extraSmallWidth = 30.w;
  static double smallWidth = 35.w;
  static double mediumWidth = 40.w;
  static double largeWidth = 55.w;
  static double extraLargeWidth = 70.w;

  //Font
  static double btnLabelFont = 11.sp;
  static double extraSmallFont = 12.sp;
  static double smallFont = 14.sp;
  static double mediumFont = 16.sp;
  static double largeFont = 18.sp;
  static double extraLargeFont = 23.sp;
  static double amountFont = 30.sp;
  static double btnSize = 9.h;

  static double intLoadHeight = 45; //Pagination height

//Widget Sizes
  static double intBorderRadius = 12;
  static double radius = 24;
}
