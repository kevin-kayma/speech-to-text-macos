import 'package:transcribe/components/components.dart';
import 'package:transcribe/config/config.dart';

import 'package:transcribe/config/utils.dart';

Future<Widget> subscriptionCard(BuildContext context) async {
  await StoreConfig().refreshSubscription();
  return (!isUserSubscribed)
      ? ClickableCard(
          bgColor: AppTheme.primaryColor,
          onTap: () {
            currentSource = Source.card;
            StoreConfig.openPaywall(context);
            // StoreConfig.showSubscription(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: ListTile(
              title: Text(
                Strings.strUpgrade,
                style: TextStyle(fontSize: Sizes.mediumFont, fontWeight: FontWeight.w900, color: AppTheme.darkFontColor),
              ),
              // subtitle: Text(Strings.strEnjoyAccess,
              //     style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //         color: AppTheme.darkFontColor)),
              leading: Lottie.asset(AssetsPath.giftjson, fit: BoxFit.fill, height: 30),
              // ImageIcon(
              //   AssetImage(AssetsPath.subscription),
              //   size: 40,
              // ),
              // trailing: HugeIcon(
              //     icon: HugeIcons.strokeRoundedArrowRight01,
              //     color: AppTheme.darkFontColor),
            ),
          ),
        )
      : const SizedBox();
}
