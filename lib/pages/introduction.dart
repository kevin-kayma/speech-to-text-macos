import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:rive/rive.dart' as rive;
import 'package:transcribe/config/config.dart';
import 'package:transcribe/config/windows_iap.dart';
import 'package:transcribe/pages/home.dart';
import 'package:transcribe/pages/subscription.dart';
import 'package:transcribe/pages/tabbar.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<Introduction> {
  Future<void> _onIntroEnd(context) async {
    try {
      Utils.addUser(isIntroLoaded: true);
      await WindowsIap().getProducts();
      await StoreConfig().refreshSubscription();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Tabbar()));
    } catch (e) {
      debugPrint(e.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Tabbar()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            // SizedBox(
            //   height: 200,
            //   width: 200,
            //   child: rive.RiveAnimation.asset(
            //     AssetsPath.audioRive,
            //   ),
            // ), //TODO
            Text(
              'Welcome to $strAppName',
              style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: Sizes.extraLargeFont),
            ),
            Text(
              'Transform Your Audio Into Text Instantly!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.lightFontColor, fontSize: Sizes.largeFont, fontWeight: FontWeight.w100),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 25, left: 25),
              child: Divider(
                thickness: 0.3,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Strings.listIntroduction.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Center(
                    // Centers each ListTile
                    child: ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        title: Text(
                          Strings.listIntroduction[index],
                          textAlign: TextAlign.center, // Center-align the text
                          style: TextStyle(
                            color: AppTheme.lightFontColor,
                            fontSize: Sizes.mediumFont,
                          ),
                        )),
                  );
                },
              ),
            ),
            SizedBox(
              width: 200,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor, // Replace with your desired color
                ),
                onPressed: () {
                  _onIntroEnd(context);
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(color: AppTheme.darkFontColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
//Intro:
// @override
//   Widget build(BuildContext context) {
//     const bodyStyle = TextStyle(fontSize: 19.0);

//     const pageDecoration = PageDecoration(
//       titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
//       bodyTextStyle: bodyStyle,
//       bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
//       pageColor: Colors.black,
//       imagePadding: EdgeInsets.zero,
//     );

//     return SafeArea(
//       child: IntroductionScreen(
//         globalBackgroundColor: Colors.black,
//         allowImplicitScrolling: true,
//         autoScrollDuration: 3000000,
        
//         pages: [
//           PageViewModel(
//             title: Strings.strIntroTitle4,
//             body: Strings.strIntroSubtitle4,
//             image: Padding(
//               padding: const EdgeInsets.all(25.0),
//               child: rive.RiveAnimation.asset(
//                 AssetsPath.audioRive,
//               ),
//             ),
//             decoration: pageDecoration,
//           ),
//           // PageViewModel(
//           //   title: Strings.strAppName,
//           //   body: Strings.strIntroSubtitle3,
//           //   image: Image.asset(
//           //     AssetsPath.applogotp,
//           //     color: AppTheme.primaryColor,
//           //   ),
//           //   decoration: pageDecoration,
//           // ),
//         ],
//         onDone: () => _onIntroEnd(context),
//         showSkipButton: false,
//         skipOrBackFlex: 0,
//         nextFlex: 0,
//         showBackButton: true,
//         back: Icon(
//           Icons.arrow_back,
//           color: AppTheme.primaryColor,
//         ),
//         next: Icon(
//           Icons.arrow_forward,
//           color: AppTheme.primaryColor,
//         ),
//         done: Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: AppTheme.lightPrimaryColor, // Outline color
//               width: 2.0, // Outline width
//             ),
//             borderRadius:
//                 BorderRadius.circular(10), // Optional: for rounded corners
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               Strings.strDone,
//               style: TextStyle(
//                 color: AppTheme.lightPrimaryColor,
//                 fontSize: Sizes.largeFont,
//               ),
//             ),
//           ),
//         ),
//         curve: Curves.fastLinearToSlowEaseIn,
//         controlsMargin: const EdgeInsets.all(16),
//         controlsPadding: const EdgeInsets.all(12.0),
//         dotsDecorator: const DotsDecorator(
//           size: Size(0.0, 0.0),
//           color: Color(0xFFBDBDBD),
//           activeSize: Size(0.0, 0.0),
//           activeShape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(25.0)),
//           ),
//         ),
//         dotsContainerDecorator: const ShapeDecoration(
//           color: Colors.black87,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8.0)),
//           ),
//         ),
//       ),
//     );
//   }