import 'package:transcribe/config/config.dart';
import 'package:transcribe/config/windows_iap.dart';
import 'package:transcribe/models/product.dart';
import 'package:transcribe/pages/pages.dart';

const myFeatureList = ['🔄 Unlimited transcriptions', '📁 Large file support', '⚡ Faster processing', '💬 Premium support'];

class Subscription extends StatelessWidget {
  const Subscription({
    super.key,
    required this.products,
    this.isFromIntro = false,
  });

  final List<Product> products;

  final bool isFromIntro;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: 12),
          Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' $strAppName Pro',
                    style: TextStyle(color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      if (isFromIntro) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MyHomePage()),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Unlock Unlimited $strAppName',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: AppTheme.lightFontColor),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 35),
                      ...List.generate(
                        4,
                        (index) => Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                myFeatureList[index],
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                style: TextStyle(color: AppTheme.lightFontColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 35),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return buildPurchaseProductCard(products[index], index, context);
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return const SizedBox(width: 30);
                              },
                              itemCount: products.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 30,
                    width: double.maxFinite,
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 12,
                        children: List.generate(
                          3,
                          (index) => index == 1
                              ? VerticalDivider(
                                  width: 4,
                                  thickness: 2,
                                  indent: 7,
                                  endIndent: 7,
                                  color: AppTheme.darkFontColor,
                                )
                              : InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    if (index == 0) {
                                      Utils.launchWebViewInApp(strTermsAndCondition);
                                    } else if (index == 1) {
                                      Utils.launchWebViewInApp(strPrivacyPolicy);
                                    }
                                  },
                                  child: Text(
                                    index == 0 ? '  Terms of Use' : 'Privacy Policy',
                                    style: TextStyle(color: AppTheme.lightFontColor),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Charged at purchase, auto-renews unless canceled.\nManage anytime via your Microsoft account. Works across all linked Windows devices.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.greyFontColor),
                  )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildPurchaseProductCard(Product product, int index, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: AppTheme.primaryColor,
        width: 3,
      ),
      color: AppTheme.primaryColor.withAlpha(75),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        const SizedBox(height: 14),
        Text(
          product.title ?? '',
          style: TextStyle(color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 14),
        Text(
          product.price ?? '',
        ),
        const SizedBox(height: 14),
        ElevatedButton(
          child: Text(
            'Subscribe',
            style: TextStyle(color: AppTheme.darkFontColor, fontSize: Sizes.mediumFont, fontWeight: FontWeight.bold),
          ),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppTheme.primaryColor)),
          onPressed: () {
            if (product.storeId != null && product.storeId != '') {
              WindowsIap().makePurchase(product.storeId!);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please try again after some time.'),
                ),
              );
            }
          },
        )
      ],
    ),
  );
}
