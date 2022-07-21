import 'package:breakpoint/breakpoint.dart';

int getCommunityLinkColumnCount(Breakpoint breakpoint) {
  if (breakpoint.window == WindowSize.xsmall) return 1;
  if (breakpoint.window == WindowSize.small) return 2;
  if (breakpoint.window == WindowSize.medium) return 3;
  if (breakpoint.window == WindowSize.large) return 3;
  if (breakpoint.window == WindowSize.xlarge) return 4;

  return 1;
}