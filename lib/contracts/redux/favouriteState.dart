import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:meta/meta.dart';

import '../favourite/favouriteItem.dart';

@immutable
class FavouriteState {
  final List<FavouriteItem> favouriteItems;

  const FavouriteState({
    this.favouriteItems,
  });

  factory FavouriteState.initial() {
    return FavouriteState(favouriteItems: List.empty(growable: true));
  }

  FavouriteState copyWith({
    List<FavouriteItem> favouriteItems,
  }) {
    return FavouriteState(
        favouriteItems: favouriteItems ?? this.favouriteItems);
  }

  factory FavouriteState.fromJson(Map<String, dynamic> json) {
    if (json == null) return FavouriteState.initial();
    try {
      return FavouriteState(
        favouriteItems: readListSafe<FavouriteItem>(
          json,
          'favouriteItems',
          (p) => FavouriteItem.fromJson(p),
        ).toList(),
      );
    } catch (exception) {
      return FavouriteState.initial();
    }
  }

  Map<String, dynamic> toJson() => {'favouriteItems': favouriteItems};
}
