


extension StringExtension on String {
  String get capsFirstLetterOfSentence => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  String get allInCaps => toUpperCase();

  String get capitalizeFirstLetterOfSentence => split(' ').map((str) => str.capsFirstLetterOfSentence).join(' ');

  String get removeWhiteSpace => replaceAll(' ', '');

  bool get isEmptyString => removeWhiteSpace.isEmpty;

  String get encodedURL => Uri.encodeFull(this);

  bool get isTrue => (this == '1' || toLowerCase() == 't' || toLowerCase() == 'true' || toLowerCase() == 'y' || toLowerCase() == 'yes');

  // String get localized => this.tr();

  String get removePackagePath {
    return split('/downloads').last;
  }


  ///Validations
  bool isPasswordValid() {
    if (length >= 8 && length <= 15) {
      return true;
    } else {
      return false;
    }
  }

  bool isPhoneNumberValid() {
    if (length > 0 && length == 10) {
      return true;
    } else {
      return false;
    }
  }

  bool isEmailValid() {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = new RegExp(pattern);
    RegExp regex = RegExp(pattern.toString());
    if (!(regex.hasMatch(this))) {
      return false;
    } else {
      return true;
    }
  }

  bool isWebsiteValid() {
    final urlRegExp = RegExp(r'((https?:www\.)|(https?://)|(www\.))[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(/[-a-zA-Z0-9()@:%_+.~#?&/=]*)?');

    if (!(urlRegExp.hasMatch(this))) {
      return false;
    } else {
      return true;
    }
  }
}

