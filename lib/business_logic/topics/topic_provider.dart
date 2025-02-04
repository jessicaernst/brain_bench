import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'topic_provider.g.dart';

Logger logger = Logger('TopicsProvider');

@riverpod
class TopicCardState extends _$TopicCardState {
  @override
  bool build({required String cardId}) {
    return false;
  }

  void toggle() {
    state = !state;
    logger.fine('TopicCardState for card toggled: $state');
  }
}
