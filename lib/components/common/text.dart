import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

Widget genericItemNameWithQuantity(context, String name, String quantity) =>
    Container(
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              name + '   ',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20),
            ),
            getBaseWidget().appChip(
              label: Text(
                'x $quantity',
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: getTheme().getSecondaryColour(context),
            )
          ]),
      margin: const EdgeInsets.all(4.0),
    );
