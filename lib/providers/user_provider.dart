import 'package:transcribe/config/config.dart';
import 'package:transcribe/models/models.dart';

class UserProvider extends StateNotifier {
  final userInfo = User()
    ..intQueries = 0
    ..intAudio = 0
    ..intRecordAudio = 0
    ..intImages = 0
    ..intShare = 0
    ..intCopy = 0
    ..intChatReview = 0
    ..intImageReview = 0
    ..isDismissImageSetting = false
    ..isIntroLoaded = false
    ..intImageQuantity = 0
    ..strImageSize = '256x256'
    ..strAlertID = '';

  UserProvider(super.state);

  User get getUser {
    final user = Boxes.getUser();

    if (user.get(Keys.keyUserID) == null) {
      return userInfo;
    } else {
      final myuser = user.get(Keys.keyUserID);
      final userInfo = User()
        ..intQueries = (myuser?.intQueries ?? 0)
        ..intAudio = (myuser?.intAudio ?? 0)
        ..intRecordAudio = (myuser?.intRecordAudio ?? 0)
        ..intImages = (myuser?.intImages ?? 0)
        ..intShare = (myuser?.intShare ?? 0)
        ..intCopy = (myuser?.intCopy ?? 0)
        ..intChatReview = (myuser?.intChatReview ?? 0)
        ..intImageReview = (myuser?.intImageReview ?? 0)
        ..isDismissImageSetting = (myuser?.isDismissImageSetting ?? false)
        ..isIntroLoaded = (myuser?.isIntroLoaded ?? false)
        ..intImageQuantity = (myuser?.intImageQuantity ?? 0)
        ..strImageSize = (myuser?.strImageSize ?? '256x256')
        ..strAlertID = (myuser?.strAlertID ?? '');
      return userInfo;
    }
  }
}

final userProvider = StateProvider<UserProvider>((ref) {
  return UserProvider(ref);
});
final userInfoProvider = StateProvider<User>((ref) {
  return UserProvider(ref).userInfo;
});
final strCurrentVersionProvider = StateProvider<String>((ref) => '');
