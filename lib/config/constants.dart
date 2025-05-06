//Basic Details
import 'package:transcribe/config/config.dart';

const String strAppName = 'Transcribe';
String strFeedbackEmail = "fireboltonline@gmail.com";
String microsoftStoreId = '9NMVZHRMBFK8';
String strFeedbackURL = 'https://docs.google.com/forms/d/e/1FAIpQLSd8Tv76gZ17MoSfsPQ3n-XAfmAvnyYHA_t-wT3PdPFNpnH27w/viewform';
String strPlayStoreID = '';

const String strStoreURL = 'https://apps.microsoft.com/store/detail/9NMVZHRMBFK8?cid=DevShareMCLPCS';

const String fontFamily = 'Karla';

//Slack
final slack = SlackNotifier('https://hooks.slack.com/services/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');
const String channelName = 'api-error';

//URLs
const String strTermsAndCondition = 'https://sites.google.com/view/transcriberspeechtotext/terms-of-use';
const String strPrivacyPolicy = 'https://sites.google.com/view/transcriberspeechtotext/privacy-policy';

//Deeplink Key
String deepLinkKey = dotenv.env[EnvKeys.deepLinkKey] ?? '';

//Initiate API
String strInitURL = 'https://firebasestorage.googleapis.com/v0/b/json-23e66.appspot.com/o/transcribe_windows.json?alt=media';

//Swagger API URLs
const String urlSwTranscriptions = "https://api.firebolt.co.in/api/Home/Transcriptions";
const String urlSwGetToken = "https://api.firebolt.co.in/api/Authentication/GetTokenValue";

//Network URLs
String urlTranscriptions = "https://api.openai.com/v1/audio/transcriptions";

const String monthlyPlan = 'monthly';
const String yearlyPlan = 'yearly';

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

//Google Ads
const int maxFailedLoadAttempts = 3;

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
  static double btnLabelFont = 8.sp;
  static double extraSmallFont = 11.sp;
  static double smallFont = 12.sp;
  static double mediumFont = 13.sp;
  static double largeFont = 15.sp;
  static double extraLargeFont = 20.sp;
  static double amountFont = 29.sp;
  static double btnSize = 8.h;

  static double intLoadHeight = 45; //Pagination height

//Widget Sizes
  static double intBorderRadius = 12;
  static double radius = 24;
}
