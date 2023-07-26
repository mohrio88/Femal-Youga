import 'package:flutter/material.dart';

import '../ConstantWidget.dart';
import '../main.dart';


class AdsFile {
  BuildContext? context;
  // RewardedAd? _rewardedAd;
  // InterstitialAd? _interstitialAd;

  AdsFile(BuildContext c) {
    context = c;
  }

  void disposeRewardedAd() {
    // if (_rewardedAd != null) {
    //   _rewardedAd!.dispose();
    // }
  }

  // BannerAd? _anchoredBanner;

  void showRewardedAd(Function function, Function function1) async {
    bool _isRewarded = false;
    // if (_rewardedAd == null) {
    //   return;
    // }
    // _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
    //   onAdShowedFullScreenContent: (RewardedAd ad) {
    //   },
    //
    //   onAdDismissedFullScreenContent: (RewardedAd ad) {
    //     ad.dispose();
    //     print("RewardedAd==true");
    //     // if (_isRewarded) {
    //       // function();
    //     // } else {
    //       // function1();
    //     // }
    //     createRewardedAd();
    //   },
    //
    //   onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
    //     ad.dispose();
    //     createRewardedAd();
    //   },
    // );
    //
    //
    //
    // _rewardedAd!.show(
    //     onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
    //       _isRewarded = true;
    //       function();
    //     });
    //
    // _rewardedAd = null;

  }

  Future<bool> checkInApp() async {
    bool isPurchase = await ConstantWidget.isPlanValid();


    print("is===$isPurchase");
    return isPurchase;
    return false;
  }

  Future<void> createRewardedAd() async {
    bool i = await checkInApp();
    if (!i) {
      // RewardedAd.load(
      //     adUnitId: getRewardBasedVideoAdUnitId(),
      //     request: request,
      //     rewardedAdLoadCallback: RewardedAdLoadCallback(
      //       onAdLoaded: (RewardedAd ad) {
      //         _rewardedAd = ad;
      //       },
      //       onAdFailedToLoad: (LoadAdError error) {
      //         _rewardedAd = null;
      //         createRewardedAd();
      //       },
      //     ));
    }
  }

  void disposeInterstitialAd() {
    // if (_interstitialAd != null) {
    //   _interstitialAd!.dispose();
    // }
  }

  void showInterstitialAd(Function function) {
    // if (_interstitialAd == null) {
      function();
    //
    //   return;
    // }
    // _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    //   onAdShowedFullScreenContent: (InterstitialAd ad) {},
    //   onAdDismissedFullScreenContent: (InterstitialAd ad) {
    //     ad.dispose();
    //     function();
    //   },
    //   onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
    //     ad.dispose();
    //     createInterstitialAd();
    //   },
    // );
    // _interstitialAd!.show();
    // _interstitialAd = null;
  }

  Future<void> createInterstitialAd({bool? isv}) async {
    bool i = await checkInApp();


    if (!i) {
      print("ads12121212121212=====true${isv}");
      // InterstitialAd.load(
      //     adUnitId: getInterstitialAdUnitId(),
      //     request: request,
      //     adLoadCallback: InterstitialAdLoadCallback(
      //       onAdLoaded: (InterstitialAd ad) {
      //
      //         _interstitialAd = ad;
      //       },
      //       onAdFailedToLoad: (LoadAdError error) {
      //         _interstitialAd = null;
      //
      //         print("i=====${error.message}");
      //         createInterstitialAd();
      //       },
      //     ));
    }
  }

  createAnchoredBanner(BuildContext context, var setState,
      {Function? function}) async {
    bool i = await checkInApp();
    // if (!i) {
    //   final AnchoredAdaptiveBannerAdSize? size =
    //   await AdSize.getAnchoredAdaptiveBannerAdSize(
    //     Orientation.portrait,
    //     MediaQuery.of(context).size.width.truncate(),
    //   );
    //
    //   if (size == null) {
    //     return;
    //   }

      // final BannerAd banner = BannerAd(
      //   size: size,
      //   request: request,
      //   adUnitId: getBannerAdUnitId(),
      //   listener: BannerAdListener(
      //     onAdLoaded: (Ad ad) {
      //       setState(() {
      //         _anchoredBanner = ad as BannerAd?;
      //       });
      //       if (function != null) {
      //         function();
      //       }
      //     },
      //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
      //       ad.dispose();
      //     },
      //     onAdOpened: (Ad ad) => {},
      //     onAdClosed: (Ad ad) => {},
      //   ),
      // );
      // banner.load();
    // }
  }

  void disposeBannerAd() {
    // if (_anchoredBanner != null) {
    //   _anchoredBanner!.dispose();
    // }
  }
}

showRewardedAd(AdsFile? adsFile, Function function, {Function? function1}) {
  if (adsFile != null) {
    adsFile.showRewardedAd(() {

      print("dmr====gjkldjklsjgh");
      function();
    }, () {
      if (function1 != null) {
        function1();
      }
    });
  }
}

disposeInterstitialAd(AdsFile? adsFile) {
  if (adsFile != null) {
    adsFile.disposeInterstitialAd();
  }
}

showInterstitialAd(AdsFile? adsFile, Function function) {
  if (adsFile != null) {
    adsFile.showInterstitialAd(() {
      function();
    });
  } else {
    function();
  }
}

disposeRewardedAd(AdsFile? adsFile) {
  if (adsFile != null) {
    adsFile.disposeRewardedAd();
  }
}

disposeBannerAd(AdsFile? adsFile) {
  if (adsFile != null) {
    adsFile.disposeBannerAd();
  }
}

showBanner(AdsFile? adsFile) {
  return adsFile == null
      ? Container()
      : Container(
    height: 0,
    // height: (getBannerAd(adsFile) != null)
    //     ? getBannerAd(adsFile)!.size.height.toDouble()
    //     : 0,
    color: Colors.white,
    // child: (getBannerAd(adsFile) != null)
    //     ? AdWidget(ad: getBannerAd(adsFile)!)
    //     : Container(),
  );
}

// BannerAd? getBannerAd(AdsFile? adsFile) {
//   BannerAd? _anchoredBanner;
//   if (adsFile != null) {
//     return (adsFile._anchoredBanner == null)
//         ? _anchoredBanner
//         : adsFile._anchoredBanner!;
//   } else {
//     return _anchoredBanner!;
//   }
// }
