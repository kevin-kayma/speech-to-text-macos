import 'package:hive_flutter/hive_flutter.dart';

class Session {
  Session._();

  static var sessionBox = Hive.box(SessionKeys.userBox);

  static bool get isReviewDialogDisplayed => (sessionBox.get(SessionKeys.isReviewDialogDisplayed) ?? false);

  static set isReviewDialogDisplayed(bool isReviewDialogDisplayed) =>
      sessionBox.put(SessionKeys.isReviewDialogDisplayed, isReviewDialogDisplayed);

  static int get chatCount => (sessionBox.get(SessionKeys.keyChatCount) ?? 0);

  static set chatCount(int chatCount) => sessionBox.put(SessionKeys.keyChatCount, chatCount);

  static int get summaryCount => (sessionBox.get(SessionKeys.keySummaryCount) ?? 0);

  static set summaryCount(int summaryCount) => sessionBox.put(SessionKeys.keySummaryCount, summaryCount);
}

class SessionKeys {
  SessionKeys._();
  static const userBox = 'transcribeUserBox';
  static const isReviewDialogDisplayed = 'isReviewDialogDisplayed';
  static const keyChatCount = 'keyChatCount';
  static const keySummaryCount = 'keySummaryCount';
}
