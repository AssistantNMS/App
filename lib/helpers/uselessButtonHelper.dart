import 'dart:math';

import 'package:flutter/material.dart';
import '../../components/dialogs/baseDialog.dart';

void uselessButtonFunc(
    BuildContext ctx, int numberOfTaps, Function() increaseUselessButtontaps) {
  simpleWidgetDialog(
    ctx,
    'Why did you click this?',
    Text(
      getMessage(numberOfTaps),
      style: const TextStyle(fontSize: 17),
      textAlign: TextAlign.center,
    ),
    buttons: [
      simpleDialogCloseButton(ctx, onTap: increaseUselessButtontaps),
    ],
    closeFunction: increaseUselessButtontaps,
  );
}

String getMessage(int numberOfTaps) {
  if (numberOfTaps > 999) {
    return 'Congrats your reward is this: 👍👍👍';
  }
  int index = Random.secure().nextInt(responses.length);
  return responses[index].replaceAll(
    '{0}',
    (numberOfTaps + 1).toString(),
  );
}

List<String> responses = [
  'It is a useless button',
  'Go do something else',
  'Why are you still here?',
  'Are you bored? Play some No Man\'s Sky',
  'Achievement: Go Away',
  'You know what useless means?',
  'This button is as useless as a sandbox in the Sahara',
  'No you',
  'This is harassment',
  'I want to speak to your Manager',
  'Drink your milk',
  'I\'m not sponsored by Captain Steve',
  'Fun fact: You clicked this button {0} times',
  'Click it 999 times and you will get a reward 😉',
  'You really are enjoying clicking this button',
  'Only 0.01% of people can complete this challenge',
  'You just wasted 5 seconds of your life',
  'Buy the Premium Version for more quotes, it only costs \$0.00',
  'Virus Free',
  'Everytime you click this button, one image is deleted from your device',
  'I forgot what to say',
];
