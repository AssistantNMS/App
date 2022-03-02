import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import '../setting/selector.dart';

class PortalGlyphViewModel {
  final bool useAltGlyphs;

  PortalGlyphViewModel({
    this.useAltGlyphs,
  });

  static PortalGlyphViewModel fromStore(Store<AppState> store) {
    return PortalGlyphViewModel(
      useAltGlyphs: getUseAltGlyphs(store.state),
    );
  }
}
