import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:meta/meta.dart';

@immutable
class ExpeditionState {
  final List<String> claimedRewards;

  const ExpeditionState({
    required this.claimedRewards,
  });

  factory ExpeditionState.initial() {
    return ExpeditionState(claimedRewards: List.empty(growable: true));
  }

  ExpeditionState copyWith({
    List<String>? claimedRewards,
  }) {
    return ExpeditionState(
      claimedRewards: claimedRewards ?? this.claimedRewards,
    );
  }

  factory ExpeditionState.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExpeditionState.initial();
    try {
      return ExpeditionState(
        claimedRewards: readStringListSafe(json, 'claimedRewards'),
      );
    } catch (exception) {
      return ExpeditionState.initial();
    }
  }

  Map<String, dynamic> toJson() => {'claimedRewards': claimedRewards};
}
