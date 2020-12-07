import 'shared.dart';

class AppShared {

  static final String KEY_USERID = 'userid';
  static final String KEY_RID = 'rid';
  static final String KEY_AGREEMENT = 'agreement';
  static final String KEY_INTERSTITIAL_AD = 'iad';

  ///保存userid
  static saveUserid(String userid){
    Future future = Shared.setValue(KEY_USERID, userid);
    future.then((isSave){
      return isSave;
    });
  }

  static Future getUserid(){
    Future future = Shared.getValue(KEY_USERID);
    return future;
  }

  static saveRid(String rid){
    Future future = Shared.setValue(KEY_RID, rid);
    future.then((isSave){
      return isSave;
    });
  }

  static Future getRid(){
    Future future = Shared.getValue(KEY_RID);
    return future;
  }

  static saveAgreement(bool is_b){
    print('saveAgreement ${is_b.toString()}');
    Future future = Shared.setValue(KEY_AGREEMENT, is_b.toString());
    future.then((isSave){
      return isSave;
    });
  }

  static Future getAgreement(){
    Future future = Shared.getValue(KEY_AGREEMENT);
    return future;
  }

  static saveInterstitialAd(String iad){
    Future future = Shared.setValue(KEY_INTERSTITIAL_AD, iad);
    future.then((isSave){
      return isSave;
    });
  }

  static Future getInterstitialAd(){
    Future future = Shared.getValue(KEY_INTERSTITIAL_AD);
    return future;
  }

}