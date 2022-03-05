import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/dialogs/asyncInputDialog.dart';
import '../../components/dialogs/optionsDialog.dart';
import '../../components/dialogs/starDialog.dart';
import '../../components/starRating.dart';

Widget feedbackPlainTextQuestionTilePresenter(BuildContext context,
        String question, String answer, Function(String) setAnswer) =>
    genericListTileWithSubtitle(
      context,
      leadingImage: null,
      name: question,
      maxLines: 5,
      subtitle: Text(
        answer,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => asyncInputDialog(context, question).then(
        (String value) {
          if (value != null) setAnswer(value);
        },
      ),
    );

Widget feedbackFiveOptionScaleQuestionTilePresenter(BuildContext context,
    String question, String answer, Function(String) setAnswer) {
  var intAnswer = int.tryParse(answer) ?? 0;
  Function(int value) setAnswerFromInt;
  setAnswerFromInt = (int value) => setAnswer(value.toString());
  return genericListTileWithSubtitle(
    context,
    leadingImage: null,
    name: question,
    maxLines: 5,
    subtitle: starRating(context, intAnswer, onTap: setAnswerFromInt),
    onTap: () => showStarDialog(context, question, onSuccess: setAnswerFromInt),
  );
}

Widget feedbackYesUnknownNoQuestionTilePresenter(BuildContext context,
    String question, String answer, Function(String) setAnswer) {
  List<DropdownOption> options = List.empty(growable: true);
  options.add(DropdownOption(getTranslations().fromKey(LocaleKey.yes)));
  options.add(DropdownOption(getTranslations().fromKey(LocaleKey.unknown)));
  options.add(DropdownOption(getTranslations().fromKey(LocaleKey.no)));
  return genericListTileWithSubtitle(
    context,
    leadingImage: null,
    name: question,
    maxLines: 5,
    subtitle: Text(
      answer,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: () => showOptionsDialog(context, question, options,
        onSuccess: (value) => setAnswer(value)),
  );
}
