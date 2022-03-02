import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import '../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../components/common/loading.dart';

class SteamBranchesPage extends StatefulWidget {
  @override
  _SteamBranchesPageWidget createState() => _SteamBranchesPageWidget();
}

class _SteamBranchesPageWidget extends State<SteamBranchesPage> {
  bool isLoading = true;
  bool hasFailed = false;
  List<SteamBranchesViewModel> branches = List.empty(growable: true);

  @override
  initState() {
    super.initState();
    this.getSteamBranches();
  }

  getSteamBranches() async {
    var branchResult =
        await getAssistantAppsSteam().getSteamBranches(AssistantAppType.NMS);

    this.setState(() {
      hasFailed = branchResult.hasFailed;
      isLoading = false;
      branches = branchResult.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: 150.0,
      trailingGlowVisible: false,
      onRefresh: () => this.getSteamBranches(),
      child: getBody(context),
      builder: (context, child, controller) => Stack(
        children: <Widget>[
          AnimatedBuilder(
            child: child,
            animation: controller,
            builder: (context, child) => Opacity(
              opacity: 1.0 - controller.value.clamp(0.0, 0.9),
              child: child,
            ),
          ),
          PositionedIndicatorContainer(
            controller: controller,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32.0),
                  child: Container(
                    color: getTheme().getScaffoldBackgroundColour(context),
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: oldLoadingSpinner(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getBody(BuildContext context) {
    if (this.hasFailed) return getLoading().customErrorWidget(context);
    if (this.isLoading) return getLoading().fullPageLoading(context);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          steamDatabaseTile(context),
          ...this
              .branches
              .map((item) => steamBranchItemTilePresenter(context, item))
              .toList(),
        ],
      ),
    );
  }
}
