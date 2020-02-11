import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class AppNavigateAction extends ReduxAction<AppState> {
  AppNavigateAction(this.index);

  final int index;

  @override
  Future<AppState> reduce() async {
    return state.copy(homePageIndex: index);
  }
}
