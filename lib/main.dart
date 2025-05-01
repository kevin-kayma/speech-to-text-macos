import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:transcribe/config/config.dart';
import 'package:transcribe/apis/network.dart';
import 'package:transcribe/models/models.dart';
import 'package:transcribe/models/paragraph.dart';
import 'package:transcribe/models/paragraphs.dart';
import 'package:transcribe/models/responsemodel.dart';
import 'package:transcribe/models/sentence.dart';
import 'package:transcribe/pages/home.dart';
import 'package:transcribe/pages/introduction.dart';
import 'package:transcribe/pages/settings.dart';
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
    // } //TODO

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

  final user = Boxes.getUser();
  final userInfo = user.get(Keys.keyUserID);
  isIntroLoaded = userInfo?.isIntroLoaded ?? false;

  await ApiService.getInitData();

  // if (initAlertData.entitlementID != '' && initAlertData.entitlementID != null) {
  //   entitlementID = initAlertData.entitlementID ?? entitlementID;
  // }

  //Subscription Store Setup
  // StoreConfig();

  await StoreConfig().initStore();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(850, 700),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: false,
  );
  await windowManager.setResizable(false);
  await windowManager.setMaximizable(false);

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

registerHiveAdapters() {
  Hive.registerAdapter(AudioModelAdapter());
  Hive.registerAdapter(UserAudioHistoryAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ResponsemodelAdapter());
  Hive.registerAdapter(ParagraphsAdapter());
  Hive.registerAdapter(ParagraphAdapter());
  Hive.registerAdapter(SentenceAdapter());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  //Firebase Analytics Setup
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);
  //TODO:
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
                PointerDeviceKind.trackpad,
              },
            ),
            title: strAppName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            // navigatorObservers: <NavigatorObserver>[observer],//TODO
            initialRoute: isIntroLoaded ? AppRoutes.tabbar : AppRoutes.intro,
            routes: {
              AppRoutes.home: (_) => const MyHomePage(),
              AppRoutes.tabbar: (_) => const Tabbar(),
              AppRoutes.intro: (_) => const Introduction(),
              AppRoutes.setting: (_) => const Settings(),
            },
          ),
        );
      },
    );
  }
}
