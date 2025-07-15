import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:transcribe/config/config.dart';
import 'package:transcribe/apis/network.dart';
import 'package:transcribe/config/session.dart';
import 'package:transcribe/models/chat_message.dart';
import 'package:transcribe/models/models.dart';
import 'package:transcribe/models/paragraph.dart';
import 'package:transcribe/models/paragraphs.dart';
import 'package:transcribe/models/responsemodel.dart';
import 'package:transcribe/models/sentence.dart';
import 'package:transcribe/pages/home.dart';
import 'package:transcribe/pages/introduction.dart';
import 'package:transcribe/pages/tabbar.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    //Load Env Variables
    await dotenv.load();

    //Firebase setup
    // await Firebase.initializeApp();

    // if (kDebugMode) {
    //   FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
    // } else {
    //   FlutterError.onError =
    //       FirebaseCrashlytics.instance.recordFlutterFatalError;

    await initialSetup();
    runApp(const ProviderScope(child: MainApp()));
  }, (error, stack) {
    // if (!kDebugMode) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    // }
  });
}

Future<void> initialSetup() async {
  ///Please do not uncomment this line it's written to test [FirebaseCrashlytics]
  // FirebaseCrashlytics.instance.crash();

  //HIVE Setup
  await Hive.initFlutter();

  // Register the type adapters
  registerHiveAdapters();

  // Open the Hive box for the User model
  await Hive.openBox<UserAudioHistory>(Keys.keyBoxAudio);
  await Hive.openBox<User>(Keys.keyBoxUser);
  await Hive.openBox(SessionKeys.userBox);

  final user = Boxes.getUser();
  final userInfo = user.get(Keys.keyUserID);
  isIntroLoaded = userInfo?.isIntroLoaded ?? false;

  await ApiService.getInitData();

  if (initAlertData.entitlementID != '' && initAlertData.entitlementID != null) {
    entitlementID = initAlertData.entitlementID ?? entitlementID;
  }

  if (initAlertData.intMaxChat != '' && initAlertData.intMaxChat != null) {
    maxChatCount = int.parse(initAlertData.intMaxChat ?? '0');
  }

  if (initAlertData.intMaxSummary != '' && initAlertData.intMaxSummary != null) {
    maxSummaryCount = int.parse(initAlertData.intMaxSummary ?? '0');
  }

  //Subscription Store Setup
  StoreConfig();

  // Set minimum window size
  if (Platform.isMacOS) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(900, 600));

    // Explicitly set the initial window size right after initialization
    await windowManager.setSize(const Size(900, 700));
    // windowManager.setAspectRatio(6 / 4);
  }
}

registerHiveAdapters() {
  Hive.registerAdapter(AudioModelAdapter());
  Hive.registerAdapter(UserAudioHistoryAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ResponsemodelAdapter());
  Hive.registerAdapter(ParagraphsAdapter());
  Hive.registerAdapter(ParagraphAdapter());
  Hive.registerAdapter(SentenceAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(MessageSenderAdapter());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  //Firebase Analytics Setup
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return ProgressHud(
          isGlobalHud: true,
          child: MacosApp(
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                // PointerDeviceKind.trackpad,
              },
            ),
            title: strAppName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            // navigatorObservers: <NavigatorObserver>[observer],
            initialRoute: isIntroLoaded ? AppRoutes.tabbar : AppRoutes.intro,
            routes: {
              AppRoutes.home: (_) => const MyHomePage(),
              AppRoutes.tabbar: (_) => const Tabbar(),
              AppRoutes.intro: (_) => const Introduction(),
            },
          ),
        );
      },
    );
  }
}
