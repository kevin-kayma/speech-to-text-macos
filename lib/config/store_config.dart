// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:transcribe/components/error.dart';
import 'package:transcribe/config/constants.dart';
import 'package:transcribe/config/globals.dart';
import 'package:transcribe/config/strings.dart';

import 'package:transcribe/config/utils.dart';
import 'package:transcribe/pages/subscription.dart';

enum SubscriptionTask { login, logout, restore }

class StoreConfig {
  late StoreConfig storeInstance;
  late PurchasesConfiguration configuration;

  StoreConfig() {
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);

    //Configure Store
    PurchasesConfiguration configuration;
    if (Platform.isIOS || Platform.isMacOS) {
      configuration = PurchasesConfiguration(appleApiKey)
        ..store = Store.appStore;
    } else {
      configuration = PurchasesConfiguration(googleApiKey)
        ..store = Store.playStore;
    }

    await Purchases.configure(configuration);
    await Purchases.collectDeviceIdentifiers();

    //Set User Is Prime Or Not
    await Utils.refreshSubscription();
  }

  /*
    We should check if we can magically change the weather 
    (subscription active) and if not, display the paywall.
  */
  static showSubscription(BuildContext context) async {
    Utils.sendAnalyticsEvent(Keys.strAnlSubscription);
    bool isConnection = await Utils.checkInternet();
    if (isConnection) {
      await Utils.refreshSubscription();
      if (!isUserSubscribed) {
        late Offerings offerings;
        try {
          offerings = await Purchases.getOfferings();

          if (offerings.current != null) {
            // current offering is available, show paywall
            // ignore: use_build_context_synchronously
            showModalBottomSheet(
              useRootNavigator: true,
              isDismissible: true,
              isScrollControlled: true,
              enableDrag: true,
              useSafeArea: true,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                  return Subscription(
                    offering: offerings.current!,
                  );
                });
              },
            );
          } else {
            showToast(Strings.strTryAgainLater);
            // offerings are empty, show a message to your user
          }
        } on PlatformException catch (error) {
          showToast(Strings.strSomethingWentWrong);
          debugPrint(error.toString());
        }
      }
    } else {
      // ignore: use_build_context_synchronously
      Utils.noNetworkDialog(context, onRetry: (() {
        Navigator.of(context).pop();
        showSubscription(context);
      }));
    }
  }

  static manageUser(SubscriptionTask task, String? newAppUserID) async {
    //start loader
    ProgressHud.showLoading();
    try {
      if (task == SubscriptionTask.login) {
        await Purchases.logIn(newAppUserID ?? '');
      } else if (task == SubscriptionTask.logout) {
        await Purchases.logOut();
      } else if (task == SubscriptionTask.restore) {
        await Purchases.restorePurchases();
      }

      //Set User Is Prime Or Not
      await Utils.refreshSubscription();
    } on PlatformException catch (error) {
      showToast(Strings.strSomethingWentWrong);

      debugPrint(error.toString());
    }
    ProgressHud.dismiss();
  }
}
