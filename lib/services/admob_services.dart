import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:speech_text/providers/my_provider.dart';

class AdmobService extends ChangeNotifier{
MyProvider myProvider=MyProvider();
InterstitialAd? _interstitialAd;

  RewardedAd? _rewardedAd;
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
_rewardedAd=ad;
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd(BuildContext context) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {

        },
        onAdDismissedFullScreenContent: (ad) {
          // Rewarded ad tam ekran kapatıldığında yapılacak işlemler
          ad.dispose();
          loadRewardedAd(); // Yeni bir rewarded ad yükle
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {

         Provider.of<MyProvider>(context,listen: false).incrementPuan();

        },
      );
      _rewardedAd = null;
    } else {
      showInterstitialAd(context);

    }
  }

void loadInterstitialAd() {
  InterstitialAd.load(
    adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Reklam birimi kimliği
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        _interstitialAd = ad;
      },
      onAdFailedToLoad: (error) {
        print('Interstitial ad failed to load: $error');
      },
    ),
  );
}

void showInterstitialAd(BuildContext context) {
  if (_interstitialAd != null) {
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        // Reklam tam ekran olarak gösterildiğinde yapılacak işlemler
      },
      onAdDismissedFullScreenContent: (ad) {
        Provider.of<MyProvider>(context,listen: false).incrementPuan();
        ad.dispose();
        loadInterstitialAd(); // Yeni bir ara reklam yükle
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  } else {
    print('Interstitial ad is not ready yet.');
  }
}
static String get testBannerAdUnitId =>
    'ca-app-pub-3940256099942544/6300978111'; // Test ad unit ID

late BannerAd _bannerAd;
bool _isAdLoaded = false;

BannerAd createBannerAd() {
  return BannerAd(
    adUnitId: testBannerAdUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        _isAdLoaded = true;
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        _isAdLoaded = false;
        print('Banner ad failed to load: $error');
      },
    ),
  );
}

void loadBannerAd() {
  _bannerAd = createBannerAd()
    ..load();
}

Widget showBannerAd() {
  if (_isAdLoaded) {
    return Container(
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd),
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
    );
  } else {
    return Container();
  }
}

void disposeBannerAd() {
  _bannerAd.dispose();
}
}