import 'dart:async';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

import '../components/scaffoldTemplates/genericPageScaffold.dart';
import '../constants/AnalyticsEvent.dart';
import '../integration/firebase.dart';

class Donation extends StatefulWidget {
  const Donation({Key key}) : super(key: key);

  @override
  _DonationWidget createState() => _DonationWidget();
}

class _DonationWidget extends State<Donation> {
  bool adIsLoading = true;
  bool adHasFailedToLoad = false;
  bool supportsNavtivePay = false;

  final _interstitialAdId = adMobInterstitialDonationPageAdUnitId();
  InterstitialAd _interstitialAd;
  StreamSubscription _interstitialAdSubscription;

  _DonationWidget() {
    getAnalytics().trackEvent(AnalyticsEvent.donationPage);
  }
  @override
  void initState() {
    super.initState();
    initializeAd();
    if (!kReleaseMode) {
      adHasFailedToLoad = true;
    }
  }

  Future<void> initializeAd() async {
    if (_interstitialAd != null && !_interstitialAd.isDisposed) {
      _interstitialAd.dispose();
    }
    if (_interstitialAdSubscription != null) {
      _interstitialAdSubscription.cancel();
    }

    _interstitialAd = InterstitialAd(unitId: _interstitialAdId);

    _interstitialAdSubscription =
        _interstitialAd.onEvent.listen(handleAdEvents);

    await _interstitialAd.load(unitId: _interstitialAdId);
  }

  void handleAdEvents(e) {
    final event = e.keys.first;
    switch (event) {
      case FullScreenAdEvent.closed:
        getAnalytics().trackEvent(AnalyticsEvent.addMobDonationPageClose);
        handleAdDismiss();
        break;
      case FullScreenAdEvent.showFailed:
      case FullScreenAdEvent.loadFailed:
        getAnalytics()
            .trackEvent(AnalyticsEvent.addMobDonationPageFailedToLoad);
        setState(() {
          adHasFailedToLoad = true;
        });
        break;
      case FullScreenAdEvent.loaded:
        setState(() {
          adIsLoading = false;
        });
        break;
      case FullScreenAdEvent.showed:
        getAnalytics().trackEvent(AnalyticsEvent.addMobDonationPageClick);
        break;
      default:
        break;
    }
  }

  void handleAdDismiss() {
    setState(() {
      adIsLoading = true;
      _interstitialAd.dispose();
      initializeAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.empty(growable: true);
    items.add(Container(
      key: const Key('donationDescrip'),
      child: Text(
        getTranslations().fromKey(LocaleKey.donationDescrip),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 50,
        style: const TextStyle(fontSize: 16),
      ),
      margin: const EdgeInsets.all(4.0),
    ));
    items.add(const Divider(key: Key('donationDescripDivider')));

    List<Widget> paymentOptions = List.empty(growable: true);

    if (!isApple) {
      paymentOptions.add(ListTile(
        key: const Key('buyMeACoffee'),
        leading: DonationImage.buyMeACoffee(),
        title: Text(getTranslations().fromKey(LocaleKey.buyMeACoffee),
            style: const TextStyle(fontSize: 20)),
        onTap: () {
          getAnalytics().trackEvent(AnalyticsEvent.externalLinkBuyMeACoffee);
          launchExternalURL(ExternalUrls.buyMeACoffee);
        },
      ));
      paymentOptions.add(ListTile(
        key: const Key('patreon'),
        leading: DonationImage.patreon(),
        title: Text(getTranslations().fromKey(LocaleKey.patreon),
            style: const TextStyle(fontSize: 20)),
        onTap: () {
          getAnalytics().trackEvent(AnalyticsEvent.externalLinkPatreon);
          launchExternalURL(ExternalUrls.patreon);
        },
      ));
      paymentOptions.add(ListTile(
        key: const Key('payPal'),
        leading: DonationImage.payPal(),
        title: Text(getTranslations().fromKey(LocaleKey.paypal),
            style: const TextStyle(fontSize: 20)),
        onTap: () {
          getAnalytics().trackEvent(AnalyticsEvent.externalLinkPayPal);
          launchExternalURL(ExternalUrls.payPal);
        },
      ));
      paymentOptions.add(ListTile(
        key: const Key('kofi'),
        leading: DonationImage.kofi(),
        title: Text(getTranslations().fromKey(LocaleKey.kofi),
            style: const TextStyle(fontSize: 20)),
        onTap: () {
          getAnalytics().trackEvent(AnalyticsEvent.externalLinkkofi);
          launchExternalURL(ExternalUrls.kofi);
        },
      ));
      paymentOptions.add(ListTile(
        key: const Key('openCollective'),
        leading: DonationImage.openCollective(),
        title: Text(getTranslations().fromKey(LocaleKey.openCollective),
            style: const TextStyle(fontSize: 20)),
        onTap: () {
          getAnalytics().trackEvent(AnalyticsEvent.externalLinkOpenCollective);
          launchExternalURL(ExternalUrls.openCollective);
        },
      ));

      if (!adHasFailedToLoad) {
        if (adIsLoading) {
          paymentOptions.add(getLoading().smallLoadingTile(context));
        } else {
          paymentOptions.add(ListTile(
            key: const Key('advert'),
            leading: getListTileImage('ad.png'),
            title: const Text("Advertisement", style: TextStyle(fontSize: 20)),
            onTap: () async {
              // Load only if not loaded
              if (!_interstitialAd.isAvailable) {
                await _interstitialAd.load(unitId: _interstitialAdId);
              } else {
                await _interstitialAd.show();
                _interstitialAd.load(unitId: _interstitialAdId);
                getAnalytics().trackEvent(AnalyticsEvent.addMobDonationPage);
              }
            },
          ));
        }
      }
    }

    if (paymentOptions.isNotEmpty) {
      items.addAll(paymentOptions);
    } else {
      items.add(ListTile(
        key: Key(LocaleKey.noItems.toString()),
        title: Text(getTranslations().fromKey(LocaleKey.noItems),
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
      ));
    }

    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.donation),
      body: listWithScrollbar(
        shrinkWrap: true,
        itemCount: items.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) => items[index],
      ),
    );
  }

  @override
  void dispose() {
    if (_interstitialAdSubscription != null) {
      _interstitialAdSubscription.cancel();
    }
    if (_interstitialAd != null && !_interstitialAd.isDisposed) {
      _interstitialAd.dispose();
    }
    super.dispose();
  }
}
