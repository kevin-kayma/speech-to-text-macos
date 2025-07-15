import 'package:transcribe/config/config.dart';

class AppTheme {
  AppTheme._();

  static const Color staticBlackColor = const Color(0xff000000);
  static const Color scaffoldBackgroundColor = const Color(0xff0F0F0F);
  static const Color greyBackgroundColor = const Color(0xff1E1E1E);
  static const Color darkFontColor = const Color(0xff212121);
  static const Color greyFontColor = const Color(0XFF9E9E9E);
  static const Color lightFontColor = const Color(0xffDFE0E2);
  static const Color subtitleColor = const Color(0xffDFE0E2);
  static const Color primaryColor = const Color(0xffA294F9);
  static const Color lightPrimaryColor = const Color(0xffCDC1FF);
  static const Color audioCardColor = const Color(0xff222831);
  static const Color cardBackgroundColor = const Color(0xff222831);
  static const Color textFieldHintColor = const Color(0xff8E8A8A);
  static const Color textFieldBorderColor = const Color(0xff645E5E);
  static const Color textFieldBackgroundColor = const Color(0xff141414);
  static const Color errorColor = const Color(0xffE57373);
  static const Color sidebarBackgroundColor = const Color(0xff222831);

  static final MacosThemeData darkTheme = MacosThemeData.dark().copyWith(
    primaryColor: AppTheme.primaryColor,
    typography: MacosTypography(
      body: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      title1: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      title2: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      title3: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      callout: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      caption1: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      caption2: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      footnote: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      headline: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      subheadline: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      largeTitle: TextStyle(fontFamily: fontFamily, color: AppTheme.lightFontColor, fontWeight: FontWeight.w400),
      color: AppTheme.lightFontColor,
    ),
    accentColor: AccentColor.purple,
    pushButtonTheme: PushButtonThemeData(color: AppTheme.primaryColor),
    canvasColor: AppTheme.scaffoldBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

// // Light theme style
//   static final ThemeData lightTheme = ThemeData(
//     fontFamily: fontFamily,
//     scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor,
//     brightness: Brightness.dark,
//     dialogTheme: DialogTheme(
//       backgroundColor: scaffoldBackgroundColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       suffixIconColor: lightFontColor,
//       // hintStyle: TextStyle(fontSize: Sizes.mediumFont),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.white, width: 1.0),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//             color: AppTheme.greyBackgroundColor,
//             width: 3.0), // Inactive border color (grey)
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(color: AppTheme.greyBackgroundColor, width: 1.0),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//     ),
//     // primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
//     // textTheme: Typography(platform: TargetPlatform.iOS).white,
//     hintColor: textFieldHintColor,
//     primaryColor: primaryColor,
//     appBarTheme: AppBarTheme(
//         centerTitle: true,
//         color: scaffoldBackgroundColor,
//         foregroundColor: lightFontColor,
//         surfaceTintColor: Colors.transparent,
//         shadowColor: Colors.transparent,
//         elevation: 0),
//     buttonTheme: ButtonThemeData(
//       highlightColor: Colors.transparent,
//       splashColor: Colors.transparent,
//       buttonColor: primaryColor,
//       textTheme: ButtonTextTheme.primary,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         foregroundColor: primaryColor,
//         backgroundColor: primaryColor,
//         textStyle: const TextStyle(
//           fontWeight: FontWeight.bold,
//         ),
//         padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30)),
//         ),
//       ),
//     ),
//     pageTransitionsTheme: const PageTransitionsTheme(
//       builders: {
//         TargetPlatform.android: CupertinoPageTransitionsBuilder(),
//         TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//       },
//     ),
//   );

// // Dark theme style
//   static final ThemeData darkTheme = ThemeData(
//     fontFamily: fontFamily,
//     scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor,
//     brightness: Brightness.dark,
//     dialogTheme: DialogTheme(
//       backgroundColor: scaffoldBackgroundColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       suffixIconColor: lightFontColor,
//       // hintStyle: TextStyle(fontSize: Sizes.mediumFont),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.white, width: 1.0),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//             color: AppTheme.greyBackgroundColor,
//             width: 3.0), // Inactive border color (grey)
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(color: AppTheme.greyBackgroundColor, width: 1.0),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//     ),
//     // primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
//     // textTheme: Typography(platform: TargetPlatform.iOS).white,
//     hintColor: textFieldHintColor,
//     primaryColor: primaryColor,
//     appBarTheme: AppBarTheme(
//         centerTitle: true,
//         color: staticBlackColor,
//         foregroundColor: lightFontColor,
//         shadowColor: Colors.transparent,
//         elevation: 0),
//     buttonTheme: ButtonThemeData(
//       highlightColor: Colors.transparent,
//       splashColor: Colors.transparent,
//       buttonColor: primaryColor,
//       textTheme: ButtonTextTheme.primary,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         foregroundColor: primaryColor,
//         backgroundColor: primaryColor,
//         textStyle: const TextStyle(
//           fontWeight: FontWeight.bold,
//         ),
//         padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30)),
//         ),
//       ),
//     ),
//     pageTransitionsTheme: const PageTransitionsTheme(
//       builders: {
//         TargetPlatform.android: CupertinoPageTransitionsBuilder(),
//         TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//       },
//     ),
//   );
}
