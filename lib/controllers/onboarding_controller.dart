import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transcribe/config/strings.dart';

final onboardingController = ChangeNotifierProvider(
  (ref) => OnboardingController(),
);

class OnboardingController extends ChangeNotifier {
  final onboardingList = [
    const OnBoardingPageModel(
      'Turn Speech Into Text in Seconds',
      AssetsPath.transcribe,
      'Accurately transcribe voice recordings, meetings, interviews, and more - all with a single tap.',
      [],
    ),
    const OnBoardingPageModel(
      'Import Audio & Video Files',
      AssetsPath.transcribeTwo,
      'Import files from your device or cloud and convert them instantly into readable text.',
      [],
    ),
    const OnBoardingPageModel(
      'Get Smart Summaries Instantly',
      AssetsPath.transcribeFour,
      'Generate concise summaries of your transcriptions to quickly understand key points without reading everything.',
      [],
    ),
    const OnBoardingPageModel(
      'Chat with Your Transcriptions',
      AssetsPath.transcribeFive,
      'Ask questions, explore details, or clarify parts of your transcription using our intelligent AI chat feature.',
      [],
    ),
  ];
}

class OnBoardingPageModel {
  const OnBoardingPageModel(
    this.title,
    this.icon,
    this.subtitle,
    this.bulletPoints,
  );

  final String title;
  final String icon;
  final String subtitle;
  final List<String> bulletPoints;
}
