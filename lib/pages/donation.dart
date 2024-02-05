import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../constants/analytics_event.dart';

class Donation extends StatefulWidget {
  const Donation({Key? key}) : super(key: key);

  @override
  _DonationWidget createState() => _DonationWidget();
}

class _DonationWidget extends State<Donation> {
  _DonationWidget() {
    getAnalytics().trackEvent(AnalyticsEvent.donationPage);
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

    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.donation),
      body: listWithScrollbar(
        shrinkWrap: true,
        itemCount: items.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) => items[index],
        scrollController: ScrollController(),
      ),
    );
  }
}
