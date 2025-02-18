import 'dart:io';

import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:transcribe/components/clickablecard.dart';
import 'package:transcribe/components/error.dart';
import 'package:transcribe/components/spacer.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/pages/home.dart';
import 'package:transcribe/pages/tabbar.dart';

class Subscription extends StatefulWidget {
  final Offering offering;
  final bool? isFromIntro;
  const Subscription(
      {super.key, required this.offering, this.isFromIntro = false});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  List<Package> listPlans = [];
  int intSelectedIndex = 0;
  @override
  void initState() {
    listPlans = widget.offering.availablePackages;
    // if (listPlans.isNotEmpty) {
    //   intSelectedIndex = listPlans.length - 1;
    // }
    Utils.sendAnalyticsEvent(Keys.proSourceView);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          Strings.strPremiumUser,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: Sizes.extraLargeFont,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (widget.isFromIntro ?? false) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Tabbar(),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          Strings.strSkip,
                          style: TextStyle(color: AppTheme.greyFontColor),
                        ),
                      ),
                    ],
                  ),
                ),
                spacer(),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Strings.listFeatures.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      title: Text(Strings.listFeatures[index],
                          style: TextStyle(
                              color: AppTheme.lightFontColor,
                              fontSize: Sizes.mediumFont,
                              fontWeight: FontWeight.w700)),
                      trailing: const Icon(Icons.done),
                    );
                  },
                ),
                spacer(),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemExtent: 85.0,
                  itemCount: listPlans.length,
                  itemBuilder: (context, index) {
                    bool isHighlighted = index == intSelectedIndex;
                    String timePeriod = getTimePeriod(listPlans[index]);

                    return Stack(
                      children: [
                        ClickableCard(
                          bgColor: isHighlighted
                              ? AppTheme.primaryColor.withAlpha(60)
                              : null,
                          onTap: () async {
                            setState(() {
                              intSelectedIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isHighlighted
                                    ? AppTheme.primaryColor
                                    : Colors
                                        .transparent, // Customize border color
                                width: 1.0, // Border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  15.0), // Optional: Add rounded corners
                            ),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  getTitle(listPlans[index]),
                                  style: TextStyle(
                                      color: AppTheme.lightFontColor,
                                      fontSize: Sizes.mediumFont,
                                      fontWeight: FontWeight.w700),
                                ),
                                subtitle: (listPlans[index]
                                            .storeProduct
                                            .subscriptionPeriod ==
                                        strProductWeekly)
                                    ? null
                                    : Text(
                                        "${listPlans[index].storeProduct.priceString} / $timePeriod",
                                        style: TextStyle(
                                            color: AppTheme.lightFontColor,
                                            fontSize: Sizes.mediumFont,
                                            fontWeight: FontWeight.w700),
                                      ),
                                trailing: Text(
                                  getSubtitle(listPlans[index]),
                                  style: TextStyle(
                                      fontSize: Sizes.mediumFont,
                                      color: AppTheme.lightFontColor,
                                      fontWeight: (listPlans[index]
                                                  .storeProduct
                                                  .subscriptionPeriod ==
                                              strProductWeekly)
                                          ? FontWeight.w700
                                          : FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                        index == 0
                            ? Align(
                                alignment: Alignment.topRight,
                                child: buildTag(),
                              )
                            : const SizedBox(),
                      ],
                    );
                  },
                ),
                spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: Sizes.largeHeight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppTheme.primaryColor)),
                      onPressed: () async {
                        Utils.sendAnalyticsEvent(Keys.strAnlPurchasePlan);
                        currentID = listPlans[intSelectedIndex]
                            .identifier
                            .replaceAll('\$rc_', '');

                        Utils.sendAnalyticsEvent(Keys.proSIdTap);
                        ProgressHud.showLoading();
                        try {
                          CustomerInfo customerInfo =
                              await Purchases.purchasePackage(
                                  listPlans[intSelectedIndex]);
                          if (customerInfo.entitlements.all[entitlementID] !=
                                  null &&
                              customerInfo.entitlements.all[entitlementID]
                                      ?.isActive ==
                                  true) {
                            showToast(Strings.strEnjoySubscription,
                                AppTheme.primaryColor);

                            isUserSubscribed = true;
                            ProgressHud.dismiss();
                            Utils.sendAnalyticsEvent(Keys.proSIdSuccess);

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutes.tabbar,
                                (Route<dynamic> route) => false);
                          } else {
                            isUserSubscribed = false;
                            Utils.sendAnalyticsEvent(Keys.proSIdFailure);
                          }
                        } on PlatformException catch (e) {
                          if (e.code != '1') {
                            Utils.sendErrorToSlack(
                                'Subscription Error ${e.message}',
                                statusCode: e.code);
                            debugPrint(e.toString());
                            showToast(Strings.strSomethingWentWrong);
                          }
                          Utils.sendAnalyticsEvent(Keys.proSIdFailure);
                        }
                        ProgressHud.dismiss();
                      },
                      child: Text(
                        hasTrial(listPlans[intSelectedIndex])
                            ? Strings.strFreeTrial.toUpperCase()
                            : Strings.strSubscribe.toUpperCase(),
                        style: TextStyle(
                            color: AppTheme.darkFontColor,
                            fontSize: Sizes.mediumFont,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await StoreConfig.manageUser(
                          SubscriptionTask.restore, null);
                      Utils.refreshSubscription();

                      if (isUserSubscribed) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.tabbar, (Route<dynamic> route) => false);
                      }
                    },
                    child: Text(
                      Strings.strRestorePurchase,
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Utils.launchWebViewInApp(strTermsAndCondition);
                      },
                      child: Text(
                        Strings.strTermsOfUse,
                        style: TextStyle(color: AppTheme.primaryColor),
                      ),
                    ),
                    Flexible(
                      child: TextButton(
                        onPressed: () {
                          Utils.launchWebViewInApp(strPrivacyPolicy);
                        },
                        child: Text(
                          Strings.strPrivacyPolicy,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Text(
                    (Platform.isIOS)
                        ? Strings.strSubscriptionFooteriOS
                        : Strings.strSubscriptionFooterAndroid,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.greyFontColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor, // The tag color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'best offer',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.darkFontColor,
          fontSize: Sizes.smallFont,
        ),
      ),
    );
  }

  String getSubtitle(Package package) {
    String strSubscriptionKey = package.storeProduct.subscriptionPeriod ?? '';
    double price = package.storeProduct.price;

    // Extracting the currency symbol (string)
    String currencySymbol =
        package.storeProduct.priceString.replaceAll(RegExp(r'[0-9.,]'), '');

    switch (strSubscriptionKey) {
      case strProductWeekly:
        String subtitle = '${package.storeProduct.priceString} / week';
        return subtitle;
      // return Strings.strWeeklySubtitle;
      case strProductMonthly:
        double monthlyPricePerWeek = price / 4.0; // Assuming 4 weeks in a month
        String subtitle =
            '$currencySymbol${monthlyPricePerWeek.toStringAsFixed(2)} / week';
        return subtitle;
      // return Strings.strMonthlySubtitle;
      case strProductYearly:
        double yearlyPricePerWeek = price / 52.0; // Assuming 52 weeks in a year
        String subtitle =
            '$currencySymbol${yearlyPricePerWeek.toStringAsFixed(2)} / week';
        return subtitle;
      // return Strings.strYearlySubtitle;
      default:
        return '';
    }
  }

  bool hasTrial(Package package) {
    final freeOffer = package.storeProduct.introductoryPrice != null &&
        package.storeProduct.introductoryPrice?.price == 0.0;
    return freeOffer;
  }

  String getTimePeriod(Package package) {
    switch (package.storeProduct.subscriptionPeriod) {
      case strProductWeekly:
        return 'Week';
      case strProductMonthly:
        return 'Month';
      case strProductYearly:
        return 'Year';
      default:
        return '';
    }
  }

  String getUnit(Package package) {
    switch (package.storeProduct.introductoryPrice?.periodUnit) {
      case PeriodUnit.day:
        return 'Days';
      case PeriodUnit.month:
        return 'Months';
      case PeriodUnit.week:
        return 'Weeks';
      case PeriodUnit.unknown:
        return '';
      default:
        return '';
    }
  }

  String getTitle(Package package) {
    String strWeekly = Strings.strWeekly;
    String strMonthly = Strings.strMonthly;
    String strYearly = Strings.strYearly;

    switch (package.storeProduct.subscriptionPeriod) {
      case strProductWeekly:
        if (hasTrial(package)) {
          String strPeriod = getUnit(package);
          String days = package
                  .storeProduct.introductoryPrice?.periodNumberOfUnits
                  .toString() ??
              '';
          strWeekly = '$strWeekly ($days $strPeriod ${Strings.strFreeTrial})';
        }
        return strWeekly;
      case strProductMonthly:
        if (hasTrial(package)) {
          String strPeriod = getUnit(package);
          String days = package
                  .storeProduct.introductoryPrice?.periodNumberOfUnits
                  .toString() ??
              '';
          strMonthly = '$strMonthly ($days $strPeriod ${Strings.strFreeTrial})';
        }
        return strMonthly;
      case strProductYearly:
        if (hasTrial(package)) {
          String strPeriod = getUnit(package);
          String days = package
                  .storeProduct.introductoryPrice?.periodNumberOfUnits
                  .toString() ??
              '';
          strYearly = '$strYearly ($days $strPeriod ${Strings.strFreeTrial})';
        }
        return strYearly;
      default:
        return '';
    }
  }
}
