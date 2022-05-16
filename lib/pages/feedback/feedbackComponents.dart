import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/starRating.dart';
import '../../constants/NmsUIConstants.dart';

Widget feedbackPlainTextQuestionTilePresenter(BuildContext context,
        String question, String answer, Function(String) setAnswer) =>
    genericListTileWithSubtitle(
      context,
      leadingImage: null,
      name: question,
      maxLines: 5,
      subtitle: Text(
        answer.isEmpty ? NMSUIConstants.FeedbackAnswerDefault : answer,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async {
        String value = await getDialog().asyncInputDialog(
          context,
          question,
          defaultText: answer,
        );

        if (value != null && value.isNotEmpty) setAnswer(value);
      },
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
    onTap: () => getDialog().showStarDialog(
      context,
      question,
      onSuccess: (BuildContext ctx, int value) => setAnswerFromInt(value),
    ),
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
    onTap: () => getDialog().showOptionsDialog(
      context,
      question,
      options,
      onSuccess: (BuildContext ctx, String value) => setAnswer(value),
    ),
  );
}
