// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide UIConstants;
import 'package:assistantnms_app/contracts/generated/feedbackQuestionAnsweredViewModel.dart';
import 'package:assistantnms_app/contracts/generated/feedbackQuestionViewModel.dart';
import 'package:flutter/material.dart';

import './feedbackComponents.dart';
import '../../constants/NmsUIConstants.dart';
import '../../contracts/enum/feedbackQuestionType.dart';
import '../../contracts/generated/feedbackAnsweredViewModel.dart';
import '../../contracts/generated/feedbackViewModel.dart';

class FeedbackQuestionsPage extends StatefulWidget {
  final FeedbackViewModel feedbackForm;
  final FeedbackAnsweredViewModel answerForm;
  const FeedbackQuestionsPage({
    Key key,
    this.feedbackForm,
    this.answerForm,
  }) : super(key: key);

  @override
  _FeedbackQuestionsWidget createState() =>
      _FeedbackQuestionsWidget(feedbackForm, answerForm);
}

class _FeedbackQuestionsWidget extends State<FeedbackQuestionsPage> {
  FeedbackViewModel feedbackForm;
  FeedbackAnsweredViewModel answerForm;
  bool isLoading = false;

  _FeedbackQuestionsWidget(this.feedbackForm, this.answerForm);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: genericItemGroup(feedbackForm.name),
    ));
    widgets.add(customDivider());

    for (int questionIndex = 0;
        questionIndex < feedbackForm.questions.length;
        questionIndex++) {
      FeedbackQuestionViewModel questionObj =
          feedbackForm.questions[questionIndex];
      void Function(String answer) onSuccess;
      onSuccess = (String answer) => setState(() {
            answerForm.answers[questionIndex].answer = answer;
          });
      if (questionObj.type == FeedbackQuestionType.PlainText) {
        widgets.add(feedbackPlainTextQuestionTilePresenter(
          context,
          questionObj.question,
          answerForm.answers[questionIndex].answer,
          onSuccess,
        ));
      }
      if (questionObj.type == FeedbackQuestionType.FiveOptionScale) {
        widgets.add(feedbackFiveOptionScaleQuestionTilePresenter(
          context,
          questionObj.question,
          answerForm.answers[questionIndex].answer,
          onSuccess,
        ));
      }
      if (questionObj.type == FeedbackQuestionType.YesUnknownNo) {
        widgets.add(feedbackYesUnknownNoQuestionTilePresenter(
          context,
          questionObj.question,
          answerForm.answers[questionIndex].answer,
          onSuccess,
        ));
      }
    }
    widgets.add(
      isLoading
          ? Center(child: getLoading().smallLoadingIndicator())
          : renderButtonWidgets(context),
    );

    widgets.add(emptySpace8x());

    return Column(
      children: [
        Expanded(
          child: listWithScrollbar(
            itemCount: widgets.length,
            itemBuilder: (context, index) => widgets[index],
          ),
        ),
      ],
    );
  }

  Widget renderButtonWidgets(BuildContext context) {
    Future Function() submitFeedback;
    submitFeedback = () async {
      setState(() {
        isLoading = true;
      });
      // Result result = await getApiRepo().sendFeedbackForm(answerForm);
      setState(() {
        isLoading = false;
      });
      // if (result.hasFailed) {
      //   getDialog().showSimpleDialog(
      //     context,
      //     getTranslations().fromKey(LocaleKey.error),
      //     Text(getTranslations().fromKey(LocaleKey.feedbackNotSubmitted)),
      //     buttonBuilder: (BuildContext ctx) => [
      //       getDialog().simpleDialogCloseButton(ctx),
      //     ],
      //   );
      // } else {
      //   getDialog().showSimpleDialog(
      //     context,
      //     getTranslations().fromKey(LocaleKey.success),
      //     Text(getTranslations().fromKey(LocaleKey.feedbackSubmitted)),
      //     buttonBuilder: (BuildContext ctx) => [
      //       getDialog().simpleDialogCloseButton(
      //         context,
      //         onTap: () async => await getNavigation().navigateHomeAsync(ctx),
      //       ),
      //     ],
      //   );
      // }
    };

    bool isButtonEnabled = submitButtonEnabled(feedbackForm, answerForm);
    String buttonText = getTranslations().fromKey(LocaleKey.submit);
    Widget button = isButtonEnabled
        ? positiveButton(
            context,
            title: buttonText,
            onPress: submitFeedback,
          )
        : disabledButton(title: buttonText);

    return Container(child: button, margin: const EdgeInsets.all(12));
  }

  bool submitButtonEnabled(
      FeedbackViewModel feedbackForm, FeedbackAnsweredViewModel answerForm) {
    int numberRequired = 1;
    for (var questionObj in feedbackForm.questions) {
      if (questionObj.type == FeedbackQuestionType.FiveOptionScale ||
          questionObj.type == FeedbackQuestionType.YesUnknownNo) {
        numberRequired++;
      }
    }

    int numberValid = 0;
    if (answerForm.answers == null || answerForm.answers.isEmpty) {
      return false;
    }
    for (FeedbackQuestionAnsweredViewModel answer in answerForm.answers) {
      if (answer.answer != null &&
          answer.answer != NMSUIConstants.FeedbackAnswerDefault &&
          answer.answer.isNotEmpty) {
        numberValid++;
      }
    }
    return numberValid >= numberRequired;
  }
}
