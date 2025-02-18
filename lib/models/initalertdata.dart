class InitAlertData {
  String? title;
  String? desc;
  String? appVersion;
  String? msgAction;
  String? msgActionButtonTitle;
  String? isAlert;
  String? isForcefullyUpdate;
  String? apiKey;
  String? backupAPIKey;
  String? alertID;
  String? isUpdated;
  String? deepKey;
  String? isDeepgram;
  String? isDiscount;
  String? isLifetime;
  String? intMaxAudio;
  String? intMaxRecordAudio;
  String? entitlementID;

  InitAlertData({
    this.title,
    this.desc,
    this.appVersion,
    this.msgAction,
    this.msgActionButtonTitle,
    this.isAlert,
    this.isForcefullyUpdate,
    this.apiKey,
    this.backupAPIKey,
    this.alertID,
    this.isUpdated,
    this.deepKey,
    this.isDeepgram,
    this.isDiscount,
    this.isLifetime,
    this.intMaxAudio,
    this.intMaxRecordAudio,
    this.entitlementID,
  });

  InitAlertData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
    appVersion = json['appVersion'];
    msgAction = json['msgAction'];
    msgActionButtonTitle = json['msgActionButtonTitle'];
    isAlert = json['isAlert'];
    isForcefullyUpdate = json['isForcefullyUpdate'];
    apiKey = json['apiKey'];
    backupAPIKey = json['backupAPIKey'];
    alertID = json['alertID'];
    isUpdated = json['isUpdated'];
    deepKey = json['deepKey'];
    isDeepgram = json['isDeepgram'];
    isDiscount = json['isDiscount'];
    isLifetime = json['isLifetime'];
    intMaxAudio = json['intMaxAudio'];
    intMaxRecordAudio = json['intMaxRecordAudio'];
    entitlementID = json['entitlementID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['desc'] = desc;
    data['appVersion'] = appVersion;
    data['msgAction'] = msgAction;
    data['msgActionButtonTitle'] = msgActionButtonTitle;
    data['isAlert'] = isAlert;
    data['isForcefullyUpdate'] = isForcefullyUpdate;
    data['apiKey'] = apiKey;
    data['backupAPIKey'] = backupAPIKey;
    data['alertID'] = alertID;
    data['isUpdated'] = isUpdated;
    data['deepKey'] = deepKey;
    data['isDeepgram'] = isDeepgram;
    data['isDiscount'] = isDiscount;
    data['isLifetime'] = isLifetime;
    data['intMaxAudio'] = intMaxAudio;
    data['intMaxRecordAudio'] = intMaxRecordAudio;
    data['entitlementID'] = entitlementID;
    return data;
  }
}
