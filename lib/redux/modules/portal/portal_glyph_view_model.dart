import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import '../setting/selector.dart';

class PortalGlyphViewModel {
  final bool useAltGlyphs;

  PortalGlyphViewModel({
    required this.useAltGlyphs,
  });

  static PortalGlyphViewModel fromStore(Store<AppState> store) {
    return PortalGlyphViewModel(
      useAltGlyphs: getUseAltGlyphs(store.state),
    );
  }
}
