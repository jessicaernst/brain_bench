import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'answer_card_provider.g.dart';

@riverpod
class AnswerCardExpanded extends _$AnswerCardExpanded {
  @override
  bool build(String questionId) => false;

  void toggle() {
    state = !state;
  }
}
