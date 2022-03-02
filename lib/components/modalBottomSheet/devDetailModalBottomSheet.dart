import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppAnimation.dart';
import '../../constants/Modal.dart';
import '../../contracts/devDetail.dart';
import '../../integration/dependencyInjection.dart';

class DevDetailBottomSheet extends StatefulWidget {
  final String itemId;
  const DevDetailBottomSheet(this.itemId, {Key key}) : super(key: key);

  @override
  _DevDetailBottomSheetWidget createState() =>
      // ignore: no_logic_in_create_state
      _DevDetailBottomSheetWidget(itemId);
}

class _DevDetailBottomSheetWidget extends State<DevDetailBottomSheet> {
  final String itemId;

  _DevDetailBottomSheetWidget(this.itemId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResultWithValue<DevDetail>>(
      future: getDataRepo().getDevDetails(context, itemId),
      builder: (BuildContext futureContext,
          AsyncSnapshot<ResultWithValue<DevDetail>> snapshot) {
        Widget errorWidget = asyncSnapshotHandler(
          futureContext,
          snapshot,
        );
        if (errorWidget != null) return errorWidget;

        Widget Function(String) titleFunc;
        titleFunc = (String text) => genericItemDescription(
              text,
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
        Widget Function(String) bodyFunc;
        bodyFunc = (String text) => genericItemDescription(
              text,
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
            );

        List<Widget Function()> widgets = [
          () => emptySpace3x(),
          () => titleFunc('AppId'),
          () => bodyFunc(itemId),
          () => customDivider(),
        ];

        for (DevProperty prop in snapshot.data.value.properties) {
          if (prop.value == null || prop.value.isEmpty) continue;
          widgets.add(() => titleFunc(prop.name));
          widgets.add(() => bodyFunc(prop.value));
          // widgets.addAll([
          //   () => titleFunc(prop.name),
          //   () => bodyFunc(prop.value),
          // ]);
          widgets.add(() => customDivider());
        }
        widgets.add(() => emptySpace8x());

        return AnimatedSize(
          duration: AppAnimation.modal,
          child: Container(
            constraints: modalDefaultSize(context),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: widgets.length,
              itemBuilder: (_, int index) => widgets[index](),
              shrinkWrap: true,
            ),
          ),
        );
      },
    );
  }
}
