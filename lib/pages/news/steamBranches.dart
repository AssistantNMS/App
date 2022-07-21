import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../components/tilePresenters/youtubersTilePresenter.dart';

class SteamBranchesPage extends StatefulWidget {
  const SteamBranchesPage({Key key}) : super(key: key);

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
    getSteamBranches();
  }

  getSteamBranches() async {
    ResultWithValue<List<SteamBranchesViewModel>> branchResult =
        await getAssistantAppsSteam().getSteamBranches(AssistantAppType.NMS);

    setState(() {
      hasFailed = branchResult.hasFailed;
      isLoading = false;
      branches = branchResult.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasFailed) return getLoading().customErrorWidget(context);
    if (isLoading) return getLoading().fullPageLoading(context);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          steamDatabaseTile(context),
          ...branches
              .map((item) => steamBranchItemTilePresenter(context, item))
              .toList(),
        ],
      ),
    );
  }
}
