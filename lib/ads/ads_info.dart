import 'dart:io';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
//
// AdRequest request = AdRequest(
//   keywords: <String>['foo', 'bar'],
//   contentUrl: 'http://foo.com/bar.html',
//   nonPersonalizedAds: true,
//
//
// );

String getInterstitialAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isIOS) {
    return 'ca-app-pub-7767787630879760/7989202473';
  }
  return "";
}

String getRewardBasedVideoAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1712485313';
  } else if (Platform.isIOS) {
    return 'ca-app-pub-7767787630879760/9110712450';
  }
  return "";
}

String getBannerAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isIOS) {
    return 'ca-app-pub-7767787630879760/4241529156';
  }
  return "";
}



// String getInterstitialAdUnitId() {
//   if (Platform.isIOS) {
//     return 'ca-app-pub-6518729804354298/8973487830';
//   } else if (Platform.isAndroid) {
//     return 'ca-app-pub-6518729804354298/8604137966';
//   }
//   return "";
// }



// String getRewardBasedVideoAdUnitId() {
//   if (Platform.isIOS) {
//     return 'ca-app-pub-3940256099942544/1712485313';
//   } else if (Platform.isAndroid) {
//     return 'ca-app-pub-3940256099942544/5224354917';
//   }
//   return "";
// }

// String getBannerAdUnitId() {
//   if (Platform.isIOS) {
//     return 'ca-app-pub-6518729804354298/4048464215';
//   } else if (Platform.isAndroid) {
//     return 'ca-app-pub-6518729804354298/8029422895';
//   }
//   return "";
// }
