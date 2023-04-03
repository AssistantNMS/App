import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/youtubers_tile_presenter.dart';
import '../../constants/nms_external_urls.dart';

class MissionGeneratorPage extends StatefulWidget {
  const MissionGeneratorPage({Key? key}) : super(key: key);

  @override
  _MissionGeneratorState createState() => _MissionGeneratorState();
}

class _MissionGeneratorState extends State<MissionGeneratorPage> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(NmsExternalUrls.deepSpaceTravelNet)) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(NmsExternalUrls.deepSpaceTravelNetMissionGen));

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: 'Kanaju Mission Generator', //
      //getTranslations().fromKey(LocaleKey.cart),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: controller)),
          kanajuTile(context),
        ],
      ),
    );
  }
}
