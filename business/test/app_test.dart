import 'package:async_redux/async_redux.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

StoreTester<AppState> storeTester =
    StoreTester<AppState>(initialState: AppState.initialState());

void main() {
  group('App Navigation', () {
    test('home should change tab', () async {
      storeTester.dispatch(AppNavigateAction(2));
      final TestInfo<AppState> info =
          await storeTester.wait(AppNavigateAction) as TestInfo<AppState>;

      expect(info.state.homePageIndex, 2);
    });
  });
}
